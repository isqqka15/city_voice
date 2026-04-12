#!/usr/bin/env python3
"""Convert photoroom.png to app icons for all Android mipmap folders."""

from PIL import Image
import os
import shutil

# Define icon sizes for Android
android_sizes = {
    'mdpi': 48,
    'hdpi': 72,
    'xhdpi': 96,
    'xxhdpi': 144,
    'xxxhdpi': 192,
}

def use_photoroom_icon():
    """Convert photoroom.png to ic_launcher.png for all mipmap folders."""
    
    source_image = '4574adfeb9458121-Photoroom.png'
    
    if not os.path.exists(source_image):
        print(f"Error: {source_image} not found!")
        return False
    
    # Open the source image
    try:
        img = Image.open(source_image)
        print(f"Source image size: {img.size}")
    except Exception as e:
        print(f"Error opening image: {e}")
        return False
    
    # Convert to RGBA if necessary (for transparency support)
    if img.mode != 'RGBA':
        img = img.convert('RGBA')
    
    # Generate icons for each mipmap folder
    base_path = 'android/app/src/main/res'
    
    for folder, size in android_sizes.items():
        mipmap_folder = os.path.join(base_path, f'mipmap-{folder}')
        
        # Resize the image to the target size
        resized_img = img.resize((size, size), Image.Resampling.LANCZOS)
        
        # Save as ic_launcher.png
        icon_path = os.path.join(mipmap_folder, 'ic_launcher.png')
        
        try:
            resized_img.save(icon_path, 'PNG')
            print(f"✓ Generated {icon_path} ({size}x{size}px)")
        except Exception as e:
            print(f"✗ Error saving {icon_path}: {e}")
            return False
    
    print("\n✓ All icons generated successfully!")
    return True

if __name__ == '__main__':
    use_photoroom_icon()
