import requests, socket, time

interval = 60
port = 8888
hostname = socket.gethostname()
ap_gateway_ip = "ap-gateway.local"
req = {"hostname": hostname}

while(True):
    try:
        r = requests.post("http://"+ap_gateway_ip+":"+str(port)+"/register", json=req)
    except Exception as e:
        print(e)
    time.sleep(interval)
