# SolrCloud helm chart
The helm chart to deploy Solr cloud. Zookeeper cluster used by SolrCloud should be deployed separately, for instance, by [zookeeper-helm](https://github.com/frizner/zookeeper-helm). In this case several SolrClouds can use one Zookeeper cluster.
## Prerequisites
To use the charts here, [Helm](https://helm.sh/) must be installed in your
Kubernetes cluster. Setting up Kubernetes and Helm and is outside the scope
of this README. Please refer to the Kubernetes and Helm documentation.
The versions required are:
  * **Helm 2.12+** - This is the earliest version of Helm tested. It is possible
    it works with earlier versions but this chart is untested for those versions.
  * **Kubernetes 1.11+**  with Beta APIs enabled. This is the earliest version of Kubernetes tested.
    It is possible that this chart works with earlier versions but it is
    untested.
  * **Persistence volume** support on underlying infrastructure

## Installing the Chart
To use the chart, you must install zookeeper cluster.
```console
$ wget https://github.com/frizner/zookeeper-helm/archive/v0.1.0.tar.gz 
$ tar -zxf v0.1.0.tar.gz
$ rm v0.1.0.tar.gz
$ helm install --name zk ./zookeeper-helm-0.1.0
```
Download this repository or the chart archive file and unpack it into a directory. Assuming this repository was unpacked into the directory `solrcloud-helm`, the chart can then be installed directly:
```bash
$ wget https://github.com/frizner/solrcloud-helm/archive/v0.1.1.tar.gz 
$ tar -zxf v0.1.1.tar.gz  
$ helm install \
--set storage=100Gi \
--set replicaCount=4 \
--set loadBalancer=Enabled \
--set solrJavaMem="-Xms4g -Xmx10g" \
--set zkHost="zk-0.zk-hs\,zk-1.zk-hs\,zk-2.zk-hs" \
--set username=superuser \
--set password=TestPassw \
--name solr01 \
./solr-helm-0.1.1/
```
As result helm should deploy release `solr01` with changed default configuration. 
The [configuration](#configuration) section lists the parameters that can be configured during the installation. Pay attention that `zkHost` parameters is set according to previous zookeeper deployment.

| WARNING: Set `username` and `password` to avoid using the standard username/password. |
| --- |
More info - [Basic Authentication Plugin](https://lucene.apache.org/solr/guide/basic-authentication-plugin.html).
## Uninstalling the Chart

To uninstall/delete the chart/`solr01` deployment:

```console
$ helm delete --purge solr01
```
The command removes all the Kubernetes components associated with the release, excluding `PersistentVolumeClaim` resources, and deletes the release.

## Cleanup orphaned Persistent Volumes

Deleting a StateFul will not delete associated Persistent Volumes.

Do the following after deleting the chart release to clean up orphaned Persistent Volumes.

```bash
$ kubectl delete pvc -l solrcloud=solr01
```

##Configuration

The following table lists some of the configurable parameters of the Solr chart and their default values.

Parameter|Description|Default
---:|:---|:---
`replicaCount`|Number of nodes in the SolrCloud. For production usage should be set at least to 4|1
`port`|Solr port|8983
`loadBalancer`|If enabled, chart will creates load balancer with public IP|`Disabled`
`loadBalancerPort`|Port used by LoadBalancer for publishing SolrCloud|`7799`
`storage`|Size of a persist volume for the each Solr node|`10Gi`
`user`|User ID to start Solr process|`8983`
`group`|Group ID to start Solr process|`8983`
`imagePullPolicy`|Image pull policy|`Always`
`image`|Docker image|`solr:7.6`
`solrTimeZone`|Time Zone|`UTC`
`solrJavaMem`|[Memory settings](https://lucene.apache.org/solr/guide/7_6/taking-solr-to-production.html#memory-and-gc-settings)|`"-Xms2g -Xmx3g"`
`zkHost`|Zookeeper servers|`zk-0.zk-hs,zk-1.zk-hs,zk-2.zk-hs`
`solrOpts`|[Override Settings in solrconfig.xml](https://lucene.apache.org/solr/guide/7_6/taking-solr-to-production.html#override-settings-in-solrconfig-xml)|`""`
`username`|The username with admin rights by default|`solradmin`
`password`|The password for admin|`S0lr@dmin`
`zookeeper.user`|Zookeeper user to apply [ACL on znodes](https://zookeeper.apache.org/doc/r3.3.3/zookeeperProgrammers.html#sc_ZooKeeperAccessControl)|`zksolr`
`zookeeper.password`|Zookeeper password to applly [ACL on znodes](https://zookeeper.apache.org/doc/r3.3.3/zookeeperProgrammers.html#sc_ZooKeeperAccessControl)|`zksolrpassw`
`podDisruptionBudget.maxUnavailable`|The number of nodes that can be [unavailable](https://kubernetes.io/docs/tasks/run-application/configure-pdb)|`1`
`resources`|CPU/Memory resource requests/limits|Requests: `1CPU`/`4Gi`, Limits: `2CPU`/`8Gi`, see [values.yaml](values.yaml)
Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name solr01 -f values.yaml ./solrcloud-helm
```
> **Tip**: You can use the default [values.yaml](values.yaml)
