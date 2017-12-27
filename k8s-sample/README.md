# NFS on K8s

## Usage

### 1. deploy nfs

```bash
$ sed -i -e "s/clusterIP: # edit or remove/# clusterIP:/" nfs.yaml
```

```bash
$ kubectl get svc nfs
NAME      TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)            AGE
nfs       ClusterIP   <* NFS IP *>   <none>        2049/TCP,111/UDP   34s</none>
```

### 2. create PV & PVC

```bash
$ sed -i -e "s/server: # edit this/server: <* NFS IP *>/" pv.yaml
```

```bash
$ kubectl create -f pv.yaml
persistentvolume "nfs-pv" created
persistentvolumeclaim "nfs-claim" created
$ kubectl get pv,pvc
NAME        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS    CLAIM               STORAGECLASS   REASON    AGE
pv/nfs-pv   1Gi        RWX            Retain           Bound     default/nfs-claim   nfs                      24s

NAME            STATUS    VOLUME    CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc/nfs-claim   Bound     nfs-pv    1Gi        RWX            nfs            24s
```

### 3. deploy apps

```bash
$ kubectl create -f pod.yaml
deployment "app" created
```

```bash
$ kubectl get po
NAME                   READY     STATUS    RESTARTS   AGE
app-6cdbf999c5-574bp   1/1       Running   0          47s
app-6cdbf999c5-nztts   1/1       Running   0          47s
nfs-69cf7d6456-5hxg2   1/1       Running   0          6m
$ kubectl exec app-6cdbf999c5-574bp -- sh -c 'echo test > /share/test.txt'
$ kubectl exec app-6cdbf999c5-nztts -- cat /share/test.txt
test
$ kubectl exec nfs-69cf7d6456-5hxg2 -- cat /exports/test.txt
test
```
