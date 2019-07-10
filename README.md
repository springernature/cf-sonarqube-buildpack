# Cloud Foundry SonarQube Buildpack

## Description
The `sonarqube-buildpack` is a [Cloud Foundry](https://www.cloudfoundry.org/) buildpack for running [SonarQube](https://www.sonarqube.org/).
It installs Java 8 and SonarQube and uses the provided `sonar.properties` file for configuration.

## Supported platforms
This buildpack is tested with Cloud Foundry 6.36.1-6.45.0. 

## How to use
To use this buildpack, specify the URI of this repository when pushing a sonar.properties file to Cloud Foundry.

```bash
$ cf push <APP-NAME> -p sonar.properties -b https://github.com/joscha-alisch/cf-sonarqube-buildpack.git
```

**Important**

You need to specify `SONARQUBE_VERSION` as an environment variable in your `manifest.yml` or commandline

```yaml
env:
  SONARQUBE_VERSION: '7.1'
```

```bash
cf set-env <APP_NAME> SONARQUBE_VERSION '7.1'
```
### SonarQube feature "Pull Request Analysis"

In case you are interested in automatically analysing pull requests with SonarQube then version 7.1. is the last one where this feature is freely available. With later versions it has been removed from the "Community Edition".

See: 
* [Release 7.2 Upgrade Notes - SonarQube-7.2](https://docs.sonarqube.org/7.2/Release7.2UpgradeNotes.html)
* [Plans & Pricing | SonarSource](https://www.sonarsource.com/plans-and-pricing/)

### Configuration 

The buildpack automatically configures the port of the SonarQube web ui. Everything else can be configured in your `sonar.properties` file.
Before starting SonarQube, the buildpack replaces all variables with syntax `${MY_ENV_VARIABLE}` in the file with the corresponding environment variable.
That makes it easy to inject secrets without the need of committing them to git.

Example:
```properties
sonar.jdbc.password=${MY_SUPER_SECRET_PASSWORD}
``` 

and then for example with the cf cli:
```bash
$ cf set-env <APP-NAME> MY_SUPER_SECRET_PASSWORD penguin
```

### Plugins

SonarQube plugins can be installed by pushing a `sonar-plugins.yml` file with your app. It should contain line separated plugin-name to plugin-version key-value pairs.

The plugin-name and version must correspond to the download file name that you can find on the plugins wiki page. 
For the [GitHub Plugin](https://docs.sonarqube.org/display/PLUG/GitHub+Plugin) it would be `sonar-github-plugin-1.4.2.1027.jar` - so the correct key-value pair is `sonar-github-plugin: 1.4.2.1027`.

Example:

```yaml
sonar-ldap-plugin: 2.2.0.608
sonar-github-plugin: 1.4.2.1027
```

**Note:** We do **not** use a real `yaml` parser under the hood. So the format must be exactly like the example given above. Otherwise the download might fail. 

## Licensing 
This buildpack is released under [MIT License](LICENSE).

## Maintenance
This buildpack is maintained by the CMS team of Springer Nature.
