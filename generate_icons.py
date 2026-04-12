#!/usr/bin/env python3
"""Generate app icons for City Voice App in all required sizes."""

from PIL import Image, ImageDraw
import os

# Define icon sizes for Android (mdpi = 48px, others scale from there)
android_sizes = {
    'mdpi': 48,
    'hdpi': 72,
    'xhdpi': 96,
    'xxhdpi': 144,
    'xxxhdpi': 192,
}

# Define icon sizes for iOS
ios_sizes = {
    'Icon-App-20x20@1x': (20, 1),
    'Icon-App-20x20@2x': (20, 2),
    'Icon-App-20x20@3x': (20, 3),
    'Icon-App-29x29@1x': (29, 1),
    'Icon-App-29x29@2x': (29, 2),
    'Icon-App-29x29@3x': (29, 3),
    'Icon-App-40x40@1x': (40, 1),
    'Icon-App-40x40@2x': (40, 2),
    'Icon-App-40x40@3x': (40, 3),
    'Icon-App-60x60@2x': (60, 2),
    'Icon-App-60x60@3x': (60, 3),
    'Icon-App-76x76@1x': (76, 1),
    'Icon-App-76x76@2x': (76, 2),
    'Icon-App-83.5x83.5@2x': (83, 2),
    'Icon-App-1024x1024@1x': (1024, 1),
}

def create_icon(size):
    """Create a microphone icon with voice waves for City Voice App."""
    # Create image with white background
    img = Image.new('RGBA', (size, size), (255, 255, 255, 0))
    draw = ImageDraw.Draw(img)
    
    # Use a bright accent color - Material Design teal
    primary_color = (0, 150, 136, 255)  # Teal
    
    # Calculate dimensions based on size
    margin = size * 0.15
    mic_x = size / 2
    mic_y = size * 0.55
    
    # Draw microphone body (rounded rectangle)
    mic_width = size * 0.35
    mic_height = size * 0.4
    
    # Microphone capsule (circle at top)
    capsule_radius = mic_width / 2
    draw.ellipse(
        [mic_x - capsule_radius, mic_y - mic_height + capsule_radius,
         mic_x + capsule_radius, mic_y - mic_height + 3*capsule_radius],
        fill=primary_color
    )
    
    # Microphone body (rectangle)
    draw.rectangle(
        [mic_x - capsule_radius*0.6, mic_y - mic_height + 2*capsule_radius,
         mic_x + capsule_radius*0.6, mic_y],
        fill=primary_color
    )
    
    # Microphone stand
    stand_width = capsule_radius * 0.3
    draw.rectangle(
        [mic_x - stand_width, mic_y,
         mic_x + stand_width, mic_y + size * 0.1],
        fill=primary_color
    )
    
    # Draw voice waves (arcs) around the microphone
    wave_count = 3
    for i in range(1, wave_count + 1):
        wave_radius = capsule_radius * 0.8 + (i * size * 0.08)
        wave_color = (0, 150, 136, int(255 * (1 - i * 0.2)))
        
        # Draw quarter circles to represent sound waves
        bbox = [
            mic_x - wave_radius,
            mic_y - mic_height + capsule_radius - wave_radius,
            mic_x + wave_radius,
            mic_y - mic_height + capsule_radius + wave_radius
        ]
        
        # Draw arcs on both sides
        draw.arc(bbox, 180, 360, fill=wave_color, width=max(1, size // 48))
        draw.arc(bbox, 0, 180, fill=wave_color, width=max(1, size // 48))
    
    return img

def generate_android_icons():
    """Generate Android app icons."""
    print("Generating Android icons...")
    base_path = 'android/app/src/main/res'
    
    for density, size in android_sizes.items():
        icon = create_icon(size)
        output_dir = os.path.join(base_path, f'mipmap-{density}')
        os.makedirs(output_dir, exist_ok=True)
        output_path = os.path.join(output_dir, 'ic_launcher.png')
        icon.save(output_path, 'PNG')
        print(f"  ✓ {output_path} ({size}x{size})")

def generate_ios_icons():
    """Generate iOS app icons."""
    print("Generating iOS icons...")
    base_path = 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
    os.makedirs(base_path, exist_ok=True)
    
    for filename, (base_size, scale) in ios_sizes.items():
        size = base_size * scale
        icon = create_icon(size)
        output_path = os.path.join(base_path, f'{filename}.png')
        icon.save(output_path, 'PNG')
        print(f"  ✓ {output_path} ({size}x{size})")

def main():
    """Main function."""
    print("City Voice App - Icon Generator")
    print("=" * 50)
    
    generate_android_icons()
    print()
    generate_ios_icons()
    
    print()
    print("=" * 50)
    print("✓ All icons generated successfully!")
    print("\nIcon design: Microphone with voice waves")
    print("Color: Material Design Teal (#009688)")

if __name__ == '__main__':
    main()
