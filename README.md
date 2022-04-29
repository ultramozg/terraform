#### This example is mainly focused for learning purposes, how to configure AWS VPN client endpoint with OKTA

1. We need to generate `ca.crt` and the `server.crt` files, for this purposes you can use `easy-rsa`
```bash
#Download and configure easy-rsa
git clone https://github.com/OpenVPN/easy-rsa.git
cd easy-rsa/easyrsa3
./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa build-server-full server.aws-vpn.company.com nopass
find . | egrep ".key|.crt"
#Upload the certificate
aws acm import-certificate --region eu-west-1 --certificate fileb://pki/issued/server.vpn.local.crt --private-key fileb://pki/private/server.vpn.local.key --certificate-chain fileb://pki/ca.crt --profile my-admin-account
```

2. Upload newly created certificates to the `ACM`

3. Specify the ACM arn for uploaded server certificate inside the VPN resource

4. Create application inside the OKTA

5. Grab SAML metadata.xml from the OKTA and use it for creation of PROVIDER inside the AWS

6. Download the OpenVPN config it's under VPC -> Client VPN Endpoints

6. Run terraform apply and verify that is it working fine, you need to download the AWS VPN client (it's OpenVPN under the hood)