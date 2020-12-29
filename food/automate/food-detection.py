import boto3
from PIL import Image, ImageDraw, ExifTags, ImageColor
import io

def detect_labels(photo, bucket):

    client=boto3.client('rekognition', region_name='us-east-2')



    response = client.detect_labels(Image={'S3Object':{'Bucket':bucket,'Name':photo}},MaxLabels=10)
    s3_connection = boto3.resource('s3')
    s3_object = s3_connection.Object(bucket,photo)
    s3_response = s3_object.get()

    stream = io.BytesIO(s3_response['Body'].read())
    image=Image.open(stream)
    width, height = image.size
    draw = ImageDraw.Draw(image)  


    print('Detected labels for ' + photo) 
    print()   
    for label in response['Labels']:
        print ("Label: " + label['Name'])
        print ("Confidence: " + str(label['Confidence']))
        print ("Instances:")
        for instance in label['Instances']:
            print ("  Bounding box")
            print ("    Top: " + str(instance['BoundingBox']['Top']))
            print ("    Left: " + str(instance['BoundingBox']['Left']))
            print ("    Width: " +  str(instance['BoundingBox']['Width']))
            print ("    Height: " +  str(instance['BoundingBox']['Height']))
            print ("  Confidence: " + str(instance['Confidence']))
        
            points = (
                (instance['BoundingBox']['Left']*width,instance['BoundingBox']['Top']*height),
                (instance['BoundingBox']['Left']*width + instance['BoundingBox']['Width']*width, instance['BoundingBox']['Top']*height),
                (instance['BoundingBox']['Left']*width + instance['BoundingBox']['Width']*width, instance['BoundingBox']['Top']*height + instance['BoundingBox']['Height']*height),
                (instance['BoundingBox']['Left']*width, instance['BoundingBox']['Top'] *height+ instance['BoundingBox']['Height']*height),
                (instance['BoundingBox']['Left']*width, instance['BoundingBox']['Top']*height)
            )
            draw.line(points, fill='#00d400', width=2)
            print()


        print ("Parents:")
        for parent in label['Parents']:
            print ("   " + parent['Name'])
        print ("----------")
        print ()

    image.show()
    return len(response['Labels'])


def main():
    photo='images/stake.jpg'
    bucket='firstbucketrawan'
    label_count=detect_labels(photo, bucket)
    print("Labels detected: " + str(label_count))
	


if __name__ == "__main__":
    main()