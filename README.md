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

* https://markn.ca/2018/02/python-extension-modules-in-aws-lambda/
* https://gist.github.com/joseph-zhong/372a47bb618111dcd2c81008d00357b2
* https://github.com/aeddi/aws-lambda-python-opencv/blob/master/build.sh
* https://www.pyimagesearch.com/2015/07/27/installing-opencv-3-0-for-both-python-2-7-and-python-3-on-your-raspberry-pi-2/
* https://www.pyimagesearch.com/2015/07/20/install-opencv-3-0-and-python-3-4-on-ubuntu/

https://github.com/opencv/opencv/issues/6464