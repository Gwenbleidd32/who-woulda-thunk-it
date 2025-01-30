#!/bin/bash
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Get the IMDSv2 token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Background the curl requests
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/local-ipv4 &> /tmp/local_ipv4 &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone &> /tmp/az &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/ &> /tmp/macid &
wait

macid=$(cat /tmp/macid)
local_ipv4=$(cat /tmp/local_ipv4)
az=$(cat /tmp/az)
vpc=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${macid}/vpc-id)

# Use single quotes for the echo command
echo '
<!doctype html>
<html>

<head>
<title>osaka-template</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">
<style>
body,h1 {font-family: "Raleway", sans-serif}
body, html {height: 100%}
.bgimg {
  background-image: url("https://storage.googleapis.com/a-dream/don.jpg");
  min-height: 100%;
  background-position: center;
  background-size: cover;
}

.w3-display-middle {
    background-color: rgba(0, 0, 0, 0.466); /* Adjust the rgba values for desired transparency */
    padding: 20px; /* Add padding to make it look better */
    border-radius: 10px; /* Optional: adds rounded corners */
}

.rounded-image {
    border-radius: 25px; /* Adjust the value as needed */
}
</style>
</head>

<body>
<div class="bgimg w3-display-container w3-animate-opacity w3-text-white">
<div class="w3-display-topleft w3-padding-large w3-xlarge">
<img src="https://storage.googleapis.com/a-dream/any.png" alt="Descriptive Alt Text" width="40%" height="40%" class="rounded-image">
</div>
<div class="w3-display-middle">
<h1 class="w3-jumbo w3-animate-top">大阪</h1>
<hr class="w3-border-grey" style="margin:auto;width:40%">
<p class="w3-large w3-center">どうとんぼり</p>
</div>
<div class="w3-display-bottomleft w3-padding-small transparent-background outlined-text">
<h2>Welcome to AWS</h2>
<h3>Configuration Information</h3>
<p><b>Instance Name:</b> '"$(hostname -f)"'</p>
<p><b>Instance Private IP Address: </b> '"${local_ipv4}"'</p>
<p><b>Availability Zone: </b> '"${az}"'</p>
<p><b>VPC ID:</b> '"${vpc}"'</p>
</div>
</div>
</body>
</html>
' > /var/www/html/index.html

# Clean up the temp files
rm -f /tmp/local_ipv4 /tmp/az /tmp/macid
