要给 Ubuntu 用户 "og-admin" 授予所有的 `kubectl` 权限，你需要在 Kubernetes 集群中创建一个新的 ServiceAccount，然后将 ClusterRoleBinding 绑定到这个 ServiceAccount。这样，用户 "og-admin" 就可以使用这个 ServiceAccount 的凭证来运行 `kubectl` 命令。

以下是具体的步骤：

1. **创建 ServiceAccount**：

    ```bash
    kubectl create serviceaccount og-admin
    ```

2. **创建 ClusterRoleBinding**：

    ```bash
    kubectl create clusterrolebinding og-admin-cluster-admin --serviceaccount=default:og-admin --clusterrole=cluster-admin
    ```

3. **获取 ServiceAccount 的 Token**：

    ```bash
    TOKEN=$(kubectl get secrets $(kubectl get serviceaccount og-admin -o jsonpath='{.secrets[0].name}') -o jsonpath='{.data.token}' | base64 --decode)
    ```

4. **创建 kubeconfig 文件**：

    首先，获取当前集群的名称和服务器地址：

    ```bash
    CLUSTER_NAME=$(kubectl config view --minify -o jsonpath='{.clusters[0].name}')
    SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
    ```

    然后，使用这些信息创建一个新的 kubeconfig 文件：

    ```bash
    kubectl config set-cluster ${CLUSTER_NAME} --kubeconfig=/home/ubuntu/.kube/config --server=${SERVER} --insecure-skip-tls-verify=true
    kubectl config set-credentials og-admin --kubeconfig=/home/ubuntu/.kube/config --token=${TOKEN}
    kubectl config set-context ${CLUSTER_NAME} --kubeconfig=/home/ubuntu/.kube/config --cluster=${CLUSTER_NAME} --user=og-admin
    kubectl config use-context ${CLUSTER_NAME} --kubeconfig=/home/ubuntu/.kube/config
    ```

    这将创建一个新的 kubeconfig 文件 `/home/og-admin/.kube/config`，用户 "og-admin" 可以使用这个文件来运行 `kubectl` 命令。

请注意，这将给用户 "og-admin" 授予集群的所有权限，这可能会带来安全风险。你应该根据你的安全策略来配置这些权限。