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
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>Europe</title>
            <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
            <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">
            <style>
                body,h1 {font-family: "Raleway", sans-serif}
                body, html {height: 100%}
                .bgimg {
                  background-image: url('https://storage.googleapis.com/a-dream/milano3.jpg');
                  min-height: 100%;
                  background-position: center;
                  background-size: cover;
                }

                .w3-display-middle {
                  background-image: url('https://storage.googleapis.com/a-dream/squeeze.png');
                  background-size: cover;
                  padding: 250px;
                  border-radius: 25px;
                  text-align: center;
                }

                button { 
                  font-size: 2em; 
                  padding: 10px 20px; 
                  background: transparent;
                  color: white;
                  border: 2px solid white;
                  cursor: pointer;
                }

                button:hover {
                  background: rgba(255, 255, 255, 0.2);
                }
            </style>
        </head>
        <body>
		<div class="bgimg w3-display-container w3-animate-opacity w3-text-white">
		<div class="w3-display-middle">
			<h1>Got Milk?</h1>
			<button onclick="window.location.href='https://www.instagram.com/lina__melon/'">Mayhaps</button>
		</div>
		</div>

  </body>
</html>
' > /var/www/html/index.html

# Clean up the temp files
rm -f /tmp/local_ipv4 /tmp/az /tmp/macid
