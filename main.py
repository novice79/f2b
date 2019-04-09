#!/usr/bin/env python3
import os
import subprocess
from sanic import Sanic
# from sanic.response import json
import sanic.response as res
from sanic.log import logger
import logging

app = Sanic()
logging.basicConfig(format='%(asctime)s %(message)s', filename='/data/db/novice-ban.log', level=logging.INFO)
def dict2obj(in_dict):
    class Struct(object):
        def __init__(self, in_dict):
            for key, value in in_dict.items():
                if isinstance(value, (list, tuple)):
                    setattr(
                        self, key,
                        [Struct(sub_dict) if isinstance(sub_dict, dict)
                         else sub_dict for sub_dict in value])
                else:
                    setattr(
                        self, key,
                        Struct(value) if isinstance(value, dict)
                        else value)
    return [Struct(sub_dict) for sub_dict in in_dict] \
        if isinstance(in_dict, list) else Struct(in_dict)
            
@app.route("/")
async def index(req):
    return res.json({"hello": "world"})
@app.post('/login-failed')
async def login_failed(req):
    # logger.info(f"{req.json}")    
    data = dict2obj(req.json)
    if not ( hasattr(data, 'token') and hasattr(data, 'ip') ):
        return res.text('invalid')
    if os.environ.get('ACCESS_TOKEN') == data.token:
        logger.info(f"failed_ip: {data.ip}")
    return res.text('POST request - {}'.format(req.json))


if __name__ == "__main__":
    app.run(
        host="0.0.0.0", 
        port=7000, 
        debug=False, 
        access_log=False
    )