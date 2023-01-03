import json
from PIL import Image, ImageDraw, ImageFont
import os
import click
from dataclasses import dataclass
import uuid

# set paths
current_path = os.path.dirname(os.path.abspath(__file__))
font1_path = os.path.join(current_path, 'fonts/Poppins-SemiBold.ttf')
font2_path = os.path.join(current_path, 'fonts/Poppins-Regular.ttf')
overlay_path = os.path.join(current_path, 'overlay.png')
backgrounds_path = os.path.join(current_path, 'backgrounds')

# image not found exception
class Error(Exception):
    def __init__(self, code: str, message: str):
        self.message = message
        self.code = code
    
    def __str__(self):
        data = {
            'status': 'error',
            'code': self.code,
            'data': self.message
        }
        return json.dumps(data, indent=4)



@dataclass
class Params:
    image: str
    out: str
    date: str
    origin: str
    title: str


def get_background(img: str) -> str:
    # get background
    images = os.listdir(backgrounds_path)
    if f'{img}.jpg' in images:
        return os.path.join(backgrounds_path, f'{img}.jpg')
    raise Error(code='ImageNotFound', message=f'Image {img} not found')


def run_gen_image(params: Params):
    # load image
    bg = get_background(params.image)
    image = Image.open(bg)
    image = image.convert('RGBA')
    width_resize = 1080
    height_resize = image.height * width_resize // image.width
    image = image.resize((width_resize, height_resize))

    # add overlay
    overlay = Image.new('RGBA', image.size, (21, 195, 214, 128))
    overlay = overlay.convert('RGBA')
    overlay.putalpha(int(255 * 0.75))
    image = Image.alpha_composite(image, overlay)

    # create a draw object
    draw = ImageDraw.Draw(image)
    font1 = ImageFont.truetype(font1_path, 48)
    font2 = ImageFont.truetype(font2_path, 32)

    # add date
    draw.text((32, 32),
              params.date, font=font2, fill=(255, 255, 255))

    # add origin
    text_width, text_height = draw.textsize(params.origin, font=font2)
    text_y = image.height - text_height - 32
    draw.text((32, text_y), params.origin, font=font2)

    # add title
    lines = [{'isOk': False, 'text': params.title}]
    countLines = 0
    while countLines < len(lines) and lines[countLines]['isOk'] == False:
        text = lines[countLines]['text']
        text_width, text_height = draw.textsize(text, font=font1)
        if text_width <= image.width-32:
            lines[countLines]['isOk'] = True
            countLines += 1
            continue
        if len(lines) <= countLines+1:
            lines.append({'isOk': False, 'text': ''})
        lines[countLines +
              1]['text'] = text[text.rfind(' '):] + lines[countLines+1]['text']
        lines[countLines]['text'] = text[:text.rfind(' ')]

    line_height = 0
    for i in range(len(lines)):
        text_width, text_height = draw.textsize(lines[i]['text'], font=font1)
        text_y = ((image.height - text_height) // 2) - 88
        draw.text((32, text_y + (i * text_height) + line_height),
                  lines[i]['text'].strip(), font=font1, fill=(255, 255, 255))
        line_height += 20

    image.convert('RGB').save(params.out)


@click.command()
@click.option('--image', required=True, help='Path to the image')
@click.option('--out', default='/tmp', help='Path to the output folder')
@click.option('--date', required=True, help='Date of the post')
@click.option('--origin', required=True, help='Origin of the post')
@click.option('--title', required=True, help='Title of the post')
def gen_image(image, out, date, origin, title):
    try:
        out_image_name = f'{uuid.uuid4()}.jpg'
        out_image_path = os.path.join(out, out_image_name)
        params = Params(image, out_image_path, date, origin, title)
        run_gen_image(params)
        data = {
            'status': 'success',
            'code': 'GenImageSuccess',
            'data': out_image_path
        }
        print(json.dumps(data, indent=4))
    except Error as e:
        print(e)


if __name__ == '__main__':
    gen_image()
