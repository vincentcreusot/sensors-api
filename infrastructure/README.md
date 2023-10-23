# Infrastructure management
I am trying to provide the infrastructure as code to manage the rollout of the solution.
## Requirements
- aws cli
- terraform

## IoT part
The things that send sensors values need to be authenticated by AWS IoT.
For that I use the Just In Time Registration system explained here [JITR](https://docs.aws.amazon.com/iot/latest/developerguide/auto-register-device-cert.html).

