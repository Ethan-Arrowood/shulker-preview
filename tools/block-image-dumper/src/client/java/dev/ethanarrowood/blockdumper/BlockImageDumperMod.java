package dev.ethanarrowood.blockdumper;

import com.mojang.blaze3d.platform.NativeImage;
import net.fabricmc.api.ClientModInitializer;
import net.fabricmc.fabric.api.client.event.lifecycle.v1.ClientTickEvents;
import net.fabricmc.fabric.api.client.keymapping.v1.KeyMappingHelper;
import net.minecraft.client.KeyMapping;
import net.minecraft.client.Minecraft;
import net.minecraft.client.Screenshot;
import net.minecraft.client.gui.GuiGraphicsExtractor;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.network.chat.Component;
import net.minecraft.resources.Identifier;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.Items;
import org.lwjgl.glfw.GLFW;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

public class BlockImageDumperMod implements ClientModInitializer {

    // --- Shared state (all accessed only on the main/render thread) ---
    static boolean dumping = false;
    static boolean waitingForScreenshot = false;
    // True only in the frame where onGuiExtract actually drew the item.
    // executePendingTasks() (which fires screenshot callbacks) runs BETWEEN
    // extract() and renderFrame() RETURN, so we must gate the screenshot on
    // whether the item was actually drawn this frame — not just on the flag state.
    static boolean itemRenderedThisFrame = false;
    static int currentIndex = 0;
    static final List<Item> items = new ArrayList<>();
    static Path outputDir;
    static int originalGuiScale;
    static int successCount = 0;
    static int failedCount = 0;

    private static KeyMapping dumpKey;

    @Override
    public void onInitializeClient() {
        // Register the F7 key binding (package changed to keymapping in 26.1)
        dumpKey = KeyMappingHelper.registerKeyMapping(new KeyMapping(
            "key.block-image-dumper.dump",
            GLFW.GLFW_KEY_F7,
            KeyMapping.Category.MISC
        ));

        // Poll for key presses each tick; start dump when world is ready.
        ClientTickEvents.END_CLIENT_TICK.register(client -> {
            while (dumpKey.consumeClick()) {
                if (!dumping && client.level != null && client.player != null) {
                    startDump(client);
                }
            }
        });
    }

    // ------------------------------------------------------------------ //
    //  Dump lifecycle                                                      //
    // ------------------------------------------------------------------ //

    private static void startDump(Minecraft client) {
        outputDir = client.gameDirectory.toPath().resolve("block-images");
        try {
            Files.createDirectories(outputDir);
        } catch (IOException e) {
            client.player.sendSystemMessage(
                Component.literal("[dumper] ERROR creating output dir: " + e.getMessage()));
            return;
        }

        // Collect all non-air items into our work list.
        items.clear();
        for (Item item : BuiltInRegistries.ITEM) {
            if (item != Items.AIR) {
                items.add(item);
            }
        }
        if (items.isEmpty()) {
            client.player.sendSystemMessage(Component.literal("[dumper] No items found!"));
            return;
        }

        currentIndex = 0;
        successCount = 0;
        failedCount = 0;
        waitingForScreenshot = false;
        itemRenderedThisFrame = false;

        // Force GUI scale 4 so a 16×16 GUI-pixel item → exactly 64×64 screen pixels.
        originalGuiScale = client.options.guiScale().get();
        client.options.guiScale().set(4);
        client.resizeGui();

        dumping = true;
        client.player.sendSystemMessage(Component.literal(
            "[dumper] Dumping " + items.size() + " items to: " + outputDir));
    }

    static void finishDump() {
        dumping = false;
        waitingForScreenshot = false;
        itemRenderedThisFrame = false;

        Minecraft client = Minecraft.getInstance();

        // Restore original GUI scale.
        client.options.guiScale().set(originalGuiScale);
        client.resizeGui();

        String msg = String.format("[dumper] Done: %d saved, %d failed. Output: %s",
            successCount, failedCount, outputDir);
        if (client.player != null) {
            client.player.sendSystemMessage(Component.literal(msg));
        } else {
            System.out.println(msg);
        }
    }

    // ------------------------------------------------------------------ //
    //  Called from GameRendererMixin after each fully-rendered frame.     //
    // ------------------------------------------------------------------ //

    public static void onFrameRendered() {
        if (!dumping || waitingForScreenshot) return;

        // Only screenshot if we actually drew the item during this frame's extract
        // phase.  executePendingTasks() (which resets waitingForScreenshot) runs
        // *after* extract() but *before* renderFrame() returns, so there are frames
        // where the flag is clear but the item was never put into the extractor.
        if (!itemRenderedThisFrame) return;
        itemRenderedThisFrame = false;

        Minecraft client = Minecraft.getInstance();
        if (client.player == null) {
            finishDump();
            return;
        }

        if (currentIndex >= items.size()) {
            finishDump();
            return;
        }

        waitingForScreenshot = true;

        Item item = items.get(currentIndex);
        Identifier id = BuiltInRegistries.ITEM.getKey(item);
        if (id == null) {
            // Should never happen for registered items, but guard anyway.
            currentIndex++;
            waitingForScreenshot = false;
            failedCount++;
            return;
        }
        Path outPath = outputDir.resolve(id.getPath() + ".png");

        Screenshot.takeScreenshot(client.getMainRenderTarget(), fullImage -> {
            try {
                // Two captures live in the frame: the item over BLACK at screen
                // x=[0,64) and over WHITE at x=[64,128), both y=[0,64).
                // For a pixel with straight color C and alpha A composited over
                // background B:   observed = C*A + B*(1-A)
                //   black (B=0):   obsB = C*A
                //   white (B=255): obsW = C*A + 255*(1-A)
                //   => obsW - obsB = 255*(1-A)  =>  A = 1 - (obsW - obsB)/255
                //   => C = obsB / A
                // NativeImage packs ABGR (alpha in the high byte); we treat the
                // three colour channels symmetrically so byte order is irrelevant
                // as long as alpha goes back into the high byte.
                NativeImage out = new NativeImage(NativeImage.Format.RGBA, 64, 64, false);
                for (int y = 0; y < 64; y++) {
                    for (int x = 0; x < 64; x++) {
                        int blackPx = fullImage.getPixel(x, y);
                        int whitePx = fullImage.getPixel(x + 64, y);

                        int c0b = blackPx & 0xFF, c1b = (blackPx >> 8) & 0xFF, c2b = (blackPx >> 16) & 0xFF;
                        int c0w = whitePx & 0xFF, c1w = (whitePx >> 8) & 0xFF, c2w = (whitePx >> 16) & 0xFF;

                        double diff = ((c0w - c0b) + (c1w - c1b) + (c2w - c2b)) / 3.0;
                        if (diff < 0) diff = 0;
                        if (diff > 255) diff = 255;
                        double alpha = 1.0 - diff / 255.0;

                        int outPx;
                        if (alpha <= 0.004) {
                            outPx = 0; // fully transparent
                        } else {
                            int oc0 = clamp255((int) Math.round(c0b / alpha));
                            int oc1 = clamp255((int) Math.round(c1b / alpha));
                            int oc2 = clamp255((int) Math.round(c2b / alpha));
                            int oa = clamp255((int) Math.round(alpha * 255.0));
                            outPx = (oa << 24) | (oc2 << 16) | (oc1 << 8) | oc0;
                        }
                        out.setPixel(x, y, outPx);
                    }
                }
                out.writeToFile(outPath);
                out.close();
                successCount++;
            } catch (Exception e) {
                System.err.println("[dumper] Failed to save " + id + ": " + e.getMessage());
                failedCount++;
            } finally {
                fullImage.close();
                currentIndex++;
                waitingForScreenshot = false;
            }
        });
    }

    // ------------------------------------------------------------------ //
    //  Called from GuiExtractMixin after Gui.extractRenderState runs.   //
    //  Injects item render directly into the vanilla GUI pipeline.       //
    // ------------------------------------------------------------------ //

    public static void onGuiExtract(GuiGraphicsExtractor graphics) {
        if (!dumping || waitingForScreenshot) return;
        if (currentIndex >= items.size()) return;

        // 26.1's Screenshot path force-sets alpha=255 on every pixel, so we cannot
        // read true transparency directly.  Instead we render the SAME item twice
        // side-by-side over two known backgrounds (black at GUI x=0, white at x=16)
        // in a single frame.  The screenshot callback then reconstructs real alpha
        // by comparing the two captures (alpha-from-two-backgrounds compositing).
        ItemStack stack = new ItemStack(items.get(currentIndex));

        // Pass 1: item over solid BLACK (GUI 0,0 → screen 0,0–64,64).
        graphics.fill(0, 0, 16, 16, 0xFF000000);
        graphics.item(stack, 0, 0);

        // Pass 2: item over solid WHITE (GUI 16,0 → screen 64,0–128,64).
        graphics.fill(16, 0, 32, 16, 0xFFFFFFFF);
        graphics.item(stack, 16, 0);

        // Mark that we actually drew the item this frame so onFrameRendered
        // knows it's safe to screenshot.
        itemRenderedThisFrame = true;
    }

    /** Clamp an int into the [0, 255] byte range. */
    private static int clamp255(int v) {
        return v < 0 ? 0 : (v > 255 ? 255 : v);
    }
}
