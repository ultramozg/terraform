### This is a test terraform for bring up the EKS cluster with AWS managed nodes

1. Create a role to assume for test purposes is created in the same account (with trusted entity type `AWS account`) 

2. Create policy which allows to assume this role. Choose service STS, access lewel write Assume role 

3. Attach this policy to the our test AWS IAM account.
```bash
aws sts assume-role --role-arn "arn:aws:iam::516478179338:role/admin-eks-role" --role-session-name "my-session"
```

4. Verify that this is working, add this into our cluster
```bash
aws eks update-kubeconfig --region eu-west-1 --name ex-eks --role-arn "arn:aws:iam::516478179338:role/admin-eks-role"
```

5. If we are using another IAM user , to allow `aws eks update-kubeconfig` he should have access to DescribeCluster, we could attach the policy directly to him

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeNodegroup",
                "eks:ListNodegroups",
                "eks:DescribeCluster",
                "eks:ListClusters",
                "eks:AccessKubernetesApi",
                "ssm:GetParameter",
                "eks:ListUpdates",
                "eks:ListFargateProfiles"
            ],
            "Resource": "*"
        }
    ]
}
```


##### Notice 
This example also brings up a "Bastion" host with attached role to manage EKS cluster, so to connect to the cluster you need to ssh in and launch this command

```bash
aws eks update-kubeconfig --region eu-west-1 --name ex-eks-infra
```