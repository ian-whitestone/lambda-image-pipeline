# lambda-image-pipeline


## Setting up EC2 instance

1) Used the AWS console GUI

* Used latest AMI `amzn-ami-hvm-2018.03.0.20180508-x86_64-gp2 (ami-14c5486b)`
* Used default security group with all SSH inbound traffic open

2) Make sure your pem key has the proper permissions
`$ chmod 400 my-pem-key.pem`

3) Update ssh config

```
Host ec2
    HostName ec2-##-###-###-##.compute-1.amazonaws.com
    User ec2-user
    IdentityFile ~/.ssh/my-pem-key.pem
```

4) Ssh into instance
`$ ssh ec2`


###




## Useful References

### General Articles about Extension modules in Lambda
* https://markn.ca/2018/02/python-extension-modules-in-aws-lambda/
* https://blog.mapbox.com/aws-lambda-python-magic-e0f6a407ffc6
* https://www.iheavy.com/2016/02/14/getting-errors-building-amazon-lambda-python-functions-help-howto/
* https://www.quora.com/How-do-I-create-a-Python-AWS-Lambda-zip-with-OpenCV-+-FFmpeg

### OpenCV Installation
* https://gist.github.com/joseph-zhong/372a47bb618111dcd2c81008d00357b2
* https://github.com/aeddi/aws-lambda-python-opencv/blob/master/build.sh
* https://github.com/opencv/opencv/issues/6464
* https://www.pyimagesearch.com/2015/07/27/installing-opencv-3-0-for-both-python-2-7-and-python-3-on-your-raspberry-pi-2/
* https://www.pyimagesearch.com/2015/07/20/install-opencv-3-0-and-python-3-4-on-ubuntu/

### Tesseract Installation
* https://stackoverflow.com/questions/33588262/tesseract-ocr-on-aws-lambda-via-virtualenv

### Repos with Compiled Packages
* https://github.com/Miserlou/lambda-packages
* https://github.com/mapbox/aws-lambda-python-packages