# image-convert

Recursively convert images from one format to another.

```bash
docker run -it --rm -v "$(pwd)/input_folder":/input_folder -v "$(pwd)/output_folder":/output_folder image_convert.py /input_folder /output_folder --source jpeg,heic --target jpeg
```