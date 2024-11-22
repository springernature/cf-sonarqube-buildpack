# Obsolete

This is outdated, please do not use it anymore. 

## SonarQube fails in Cloud Foundry at least since version 7.8:

https://docs.sonarqube.org/7.8/setup/upgrade-notes/
> **Elasticsearch bootstrap checks enforced**
> 
> SonarQube will now fail to start if Elasticsearch's bootstrap checks fail. That means you may need to adjust the maximum number of open files and processes for the SonarQube user as part of this upgrade (SONAR-11264).
> Plus the issue with behaving non correctly behind varnish, which adds another problem running in SNPaaS.
> https://springernature.slack.com/archives/C6THTT5SB/p1608544182084500?thread_ts=1608536168.083700&cid=C6THTT5SB

> Here is the culprit:
> https://github.com/SonarSource/sonarqube/blob/9c4f81390e6739fa09f596d359d66c181db9ad1c/server/sonar-webserver-webapi/src/main/java/org/sonar/server/platform/ws/IndexAction.java#L69

[source](https://springernature.slack.com/archives/C6THTT5SB/p1608556009090700?thread_ts=1608536168.083700&cid=C6THTT5SB)


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
