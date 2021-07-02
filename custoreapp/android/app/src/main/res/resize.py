from PIL import Image

folder  = {
    'mipmap-hdpi': (72, 72),
    'mipmap-mdpi': (48, 48),
    'mipmap-xhdpi': (96, 96),
    'mipmap-xxhdpi': (144, 144),
    'mipmap-xxxhdpi': (192, 192)
}

image = Image.open('store.png')

for elem in folder:
    new_image = image.resize(folder[elem])
    new_image.save(f'{elem}/ic_launcher.png')
    print(new_image.size)
    print()
    
