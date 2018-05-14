# Cloud Foundry SonarQube Buildpack

The `sonarqube-buildpack` is a [Cloud Foundry][https://www.cloudfoundry.org/] buildpack for running [SonarQube](https://www.sonarqube.org/).
It installs java and sonarqube and uses the provided sonar.properties file for configuration.

## Usage

To use this buildpack, specify the URI of this repository when pushing a sonar.properties file to Cloud Foundry.

```bash
$ cf push <APP-NAME> -p sonar.properties -b https://github.com/joscha-alisch/cf-sonarqube-buildpack.git
```

**Important**

You need to specify `SONARQUBE_VERSION` as an environment variable in your manifest.yml or commandline

```yaml
env:
  SONARQUBE_VERSION: '7.1'
```

```bash
cf set-env <APP_NAME> SONARQUBE_VERSION '7.1'
```


## Licensing

This buildpack is released under [MIT License](LICENSE).