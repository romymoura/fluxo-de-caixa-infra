import json
import jwt
import urllib.request
import os

def lambda_handler(event, context):
    token = event.get("authorizationToken", "").split(" ")[-1]
    identity_server_url = os.getenv("IDENTITY_SERVER_URL")

    try:
        # Busca a chave pública do Identity Server
        with urllib.request.urlopen(f"{identity_server_url}/.well-known/openid-configuration") as url:
            config = json.loads(url.read().decode())
            jwks_uri = config["jwks_uri"]

        with urllib.request.urlopen(jwks_uri) as url:
            keys = json.loads(url.read().decode())

        # Decodifica e valida o token
        decoded_token = jwt.decode(token, keys, algorithms=["RS256"], audience="api_gateway")

        return {
            "principalId": decoded_token["sub"],
            "policyDocument": {
                "Version": "2012-10-17",
                "Statement": [{
                    "Action": "execute-api:Invoke",
                    "Effect": "Allow",
                    "Resource": event["methodArn"]
                }]
            }
        }

    except Exception as e:
        return {
            "principalId": "unauthorized",
            "policyDocument": {
                "Version": "2012-10-17",
                "Statement": [{
                    "Action": "execute-api:Invoke",
                    "Effect": "Deny",
                    "Resource": event["methodArn"]
                }]
            }
        }
