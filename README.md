# kotlin-LALA
## Automatically Generating
Use the following gradle task in `generating` group to automatically translate LaLa kotlin specification and generate ten example programs
    
```
generatingExamples
```

## Setup

This tester sends calls to kotlin-compiler-server to execute code, 
set URL to ```http://localhost:8080/``` by default. 

In order to run server use the following gradle tasks:
    
* Start docker image in docker container:
```
./gradlew dockerRun    
```

* Stop and remove docker container:

```
./gradlew dockerStop dockerRemoveContainer
```
