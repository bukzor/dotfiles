module github.com/minamijoyo/tflock

go 1.16

require (
	github.com/hashicorp/logutils v1.0.0
	github.com/hashicorp/terraform v0.13.5
	github.com/mitchellh/cli v1.0.0
	k8s.io/api v0.0.0-20190816222004-e3a6b8045b0b // indirect
)

replace k8s.io/client-go => k8s.io/client-go v0.0.0-20190620085101-78d2af792bab
