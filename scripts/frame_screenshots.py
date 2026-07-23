#!/usr/bin/env python3
import os
import sys
import json
import argparse
from PIL import Image, ImageDraw, ImageFont, ImageFilter

def hex_to_rgb(hex_str, default=(37, 99, 235)):
    if not hex_str:
        return default
    cleaned = hex_str.replace('#', '').replace('0x', '').strip()
    if len(cleaned) == 8: # AARRGGBB
        cleaned = cleaned[2:]
    if len(cleaned) != 6:
        return default
    try:
        return tuple(int(cleaned[i:i+2], 16) for i in (0, 2, 4))
    except ValueError:
        return default

def create_framed_screenshot(raw_img_path, output_path, target_width, target_height, app_name, brand_color_rgb, title_text=""):
    """
    Creates a framed screenshot with a brand background gradient, title banner, 
    and a sleek device bezel matching official Google Play / App Store specifications.
    """
    canvas = Image.new("RGB", (target_width, target_height), brand_color_rgb)
    draw = ImageDraw.Draw(canvas)
    
    # 1. Subtle Background Gradient Effect
    r, g, b = brand_color_rgb
    top_color = (min(255, r + 25), min(255, g + 25), min(255, b + 25))
    bottom_color = (max(0, r - 30), max(0, g - 30), max(0, b - 30))
    
    for y in range(target_height):
        factor = y / float(target_height)
        cur_r = int(top_color[0] * (1 - factor) + bottom_color[0] * factor)
        cur_g = int(top_color[1] * (1 - factor) + bottom_color[1] * factor)
        cur_b = int(top_color[2] * (1 - factor) + bottom_color[2] * factor)
        draw.line([(0, y), (target_width, y)], fill=(cur_r, cur_g, cur_b))

    # 2. Open Raw Screenshot
    if not os.path.exists(raw_img_path):
        print(f"Warning: Raw image {raw_img_path} not found. Generating fallback canvas.")
        raw_img = Image.new("RGB", (800, 1600), (245, 247, 250))
        raw_draw = ImageDraw.Draw(raw_img)
        raw_draw.text((100, 750), app_name, fill=(30, 41, 59))
    else:
        raw_img = Image.open(raw_img_path).convert("RGB")

    # 3. Calculate Device Frame Dimensions
    header_margin = int(target_height * 0.12)
    device_margin_x = int(target_width * 0.08)
    device_width = target_width - (2 * device_margin_x)
    
    # Scale image to fit inside frame width while maintaining aspect ratio
    w_percent = device_width / float(raw_img.size[0])
    device_height = int(float(raw_img.size[1]) * float(w_percent))
    
    max_device_height = target_height - header_margin - int(target_height * 0.05)
    if device_height > max_device_height:
        device_height = max_device_height
        h_percent = device_height / float(raw_img.size[1])
        device_width = int(float(raw_img.size[0]) * float(h_percent))
        device_margin_x = (target_width - device_width) // 2

    raw_img_resized = raw_img.resize((device_width, device_height), Image.Resampling.LANCZOS)

    # 4. Device Bezel & Soft Drop Shadow
    device_x = (target_width - device_width) // 2
    device_y = header_margin + (max_device_height - device_height) // 2

    # Outer Bezel
    border_radius = int(target_width * 0.04)
    bezel_padding = int(target_width * 0.015)
    
    bezel_box = [
        device_x - bezel_padding,
        device_y - bezel_padding,
        device_x + device_width + bezel_padding,
        device_y + device_height + bezel_padding
    ]

    # Draw Bezel
    draw.rounded_rectangle(bezel_box, radius=border_radius + bezel_padding, fill=(15, 23, 42))

    # Mask Screenshot Corners to fit Bezel
    mask = Image.new("L", (device_width, device_height), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle([0, 0, device_width, device_height], radius=border_radius, fill=255)
    
    canvas.paste(raw_img_resized, (device_x, device_y), mask)

    # 5. Header Title Banner
    banner_text = title_text if title_text else app_name
    font_size = int(target_width * 0.045)
    try:
        font = ImageFont.truetype("arial.ttf", font_size)
    except IOError:
        font = ImageFont.load_default()

    # Draw Title Text (white with shadow)
    text_bbox = draw.textbbox((0, 0), banner_text, font=font)
    text_w = text_bbox[2] - text_bbox[0]
    text_x = (target_width - text_w) // 2
    text_y = int(target_height * 0.04)

    draw.text((text_x + 2, text_y + 2), banner_text, fill=(0, 0, 0, 120), font=font)
    draw.text((text_x, text_y), banner_text, fill=(255, 255, 255), font=font)

    # Save Framed Result
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    canvas.save(output_path, "PNG")
    print(f"✅ Generated framed screenshot: {output_path} ({target_width}x{target_height})")

def main():
    parser = argparse.ArgumentParser(description="Multi-tenant Store Screenshot Framer")
    parser.add_argument("--client", required=True, help="Client folder name inside clients/")
    parser.add_argument("--input-dir", default="raw_screenshots", help="Directory containing raw screenshots")
    parser.add_argument("--output-dir", default="output/store_assets", help="Base output directory")
    args = parser.parse_args()

    client_path = os.path.join("clients", args.client, "client_config.json")
    app_name = args.client
    brand_hex = "#2563eb"

    if os.path.exists(client_path):
        with open(client_path, "r", encoding="utf-8") as f:
            cfg = json.load(f)
            app_name = cfg.get("appName", args.client)
            brand_hex = cfg.get("fallbackPrimaryColor", brand_hex)

    brand_rgb = hex_to_rgb(brand_hex)

    # Target Dimensions for Google Play & App Store
    targets = {
        "android": [
            ("phone_1080x1920", 1080, 1920),
            ("tablet_7in_1200x1920", 1200, 1920),
            ("tablet_10in_1600x2560", 1600, 2560)
        ],
        "ios": [
            ("iphone_6.7in_1290x2796", 1290, 2796),
            ("iphone_6.5in_1242x2688", 1242, 2688),
            ("ipad_12.9in_2048x2732", 2048, 2732)
        ]
    }

    screenshot_files = [
        ("01_splash.png", "شاشة البداية"),
        ("02_onboarding_or_login.png", "تسجيل الدخول السهل السريع"),
        ("03_guest_home.png", "استكشف الكورسات والدورات"),
        ("04_main_screen.png", "محتوى تعليمي شامـل"),
        ("05_library_screen.png", "مكتبتي ودوراتي"),
        ("06_profile_screen.png", "إدارة الملف الشخصي")
    ]

    for store, dims in targets.items():
        for size_label, tw, th in dims:
            out_folder = os.path.join(args.output_dir, args.client, store, size_label)
            for file_name, title in screenshot_files:
                raw_path = os.path.join(args.input_dir, file_name)
                out_path = os.path.join(out_folder, file_name)
                create_framed_screenshot(raw_path, out_path, tw, th, app_name, brand_rgb, title)

if __name__ == "__main__":
    main()
