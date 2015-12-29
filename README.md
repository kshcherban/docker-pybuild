# docker-pybuild
Python debian packages building automatization

```
git clone https://github.com/kshcherban/docker-pybuild /tmp/pybuild
cd /tmp/pybuild
docker build -t pybuild .
docker run --name=suds-jurko-0.6 pybuild buildpydeb.sh suds-jurko=0.6
docker cp suds-jurko-0.6:/opt/buildroot .
docker rm suds-jurko-0.6
```

Now you can use image pybuild to build any python packages like this:
```
docker run pybuild buildpydeb.sh <package-name>=<version>
```
