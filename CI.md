## Pipeline deploy commands
```bash
# choose concourse instance
export CONTEXT='mac';  export ENDPOINT='http://localhost'
export CONTEXT='prod'; export ENDPOINT='http://target-concourse.ci.corp.adobe.com:443'

# choose acting team
export TEAM='main'

# login via browser
fly -t ${CONTEXT} login -c ${ENDPOINT} --team-name ${TEAM} -b

# choose project team
export PROJECT_TEAM='tf-manage'

# choose instance role
export ROLE='build-docker-image'

fly -t ${CONTEXT} set-pipeline -p ${ROLE} --team ${PROJECT_TEAM} -c concourse/pipelines/${ROLE}.yml
fly -t ${CONTEXT} unpause-pipeline -p ${ROLE} --team ${PROJECT_TEAM}

```
