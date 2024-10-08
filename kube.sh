#!/bin/bash

kubenet() {
    o1=$1
    kube="$(kubectl get namespace | awk 'NR>1 {print $1}')"
    IFS=$'\n' read -rd '' -a namespace <<<"$kube"

    if [ "$o1" == "logs" ]; then
        select ns in "${namespace[@]}"; do
            pod="$(kubectl get po -n $ns | awk 'NR>1 {print $1}')"
            IFS=$'\n' read -rd '' -a po <<<"$pod"
            if [ ${#po[@]} -gt 0 ]; then
                select p in "${po[@]}"; do
                    echo "Search any resource :"
                    read search
                    if [ -n "$search" ]; then
                        kubectl -n $ns logs -f $p | grep -i $search
                    else
                        kubectl -n $ns logs -f $p
                    fi
                done
            else
                echo "No resources found in $ns namespace."
            fi
            break
        done
    elif [ "$o1" == "des" ]; then
        echo "1. po"
        echo "2. deploy"
        echo "3. hpa"
        echo "4. cm"

        read -p "select option" choice
        case $choice in
            1)
                kubenet "po"
                ;;
            2)
                kubenet "deploy"
                ;;
            3)
                kubenet "hpa"
                ;;
            4)
                kubenet "cm"
                ;;
            5)
                kubenet "ds"
                ;;
            6)
                kubenet "secrets"
                ;;
            7)
                kubenet "certificates"
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
            esac
        select ns in "${namespace[@]}"; do
            pod="$(kubectl get $o1 -n $ns | awk 'NR>1 {print $1}')"
            IFS=$'\n' read -rd '' -a po <<<"$pod"
            if [ ${#po[@]} -gt 0 ]; then
                kubectl get $o1 -n $ns
                select p in "${po[@]}"; do
                    kubectl -n $ns describe po $p
                done
            else
                echo "No resources found in $ns namespace."
            fi
            break
        done
    elif [ "$o1" == "get" ]; then
        echo "1. po"
        echo "2. deploy"
        echo "3. hpa"
        echo "4. cm"

        read -p "select option" choice
        case $choice in
            1)
                kubenet "po"
                ;;
            2)
                kubenet "deploy"
                ;;
            3)
                kubenet "hpa"
                ;;
            4)
                kubenet "cm"
                ;;
            5)
                kubenet "ds"
                ;;
            6)
                kubenet "secrets"
                ;;
            7)
                kubenet "certificates"
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
        esac    
        select ns in "${namespace[@]}"; do
            echo "Search any resource :"
            read search
            pod="$(kubectl get $o1 -n $ns | awk 'NR>1 {print $1}')"
            IFS=$'\n' read -rd '' -a po <<<"$pod"
            if [ ${#po[@]} -gt 0 ]; then
                if [ -n "$search" ]; then
                    kubectl get $o1 -n $ns | grep -i $search
                else
                    kubectl get $o1 -n $ns
                fi
            else
                echo "No resources found in $ns namespace."
            fi
            break
        done
    elif [ "$o1" == "nodes" ]; then
        echo "1. get nodes"
        echo "2. describe nodes"
        echo "3. delete node"

        read -p "select option" choice
        case $choice in
            1)
                kubectl get no
                ;;
            2)
                kubenet "describe no"
                ;;
            3)
                kubenet "delete no"
                    ;;
            *)
                echo "Invalid option. Please try again."
                ;;
            esac
        nodes="$(kubectl get no | awk 'NR>1 {print $1}')"
        IFS=$'\n' read -rd '' -a node <<<"$nodes"
        select no in "${node[@]}"; do
            if [ ${#node[@]} -gt 0 ]; then
                kubectl $o1 $no
            else
                echo "No resources found in $ns namespace."
            fi
            break
        done
        elif [ "$o1" == "edit" ]; then
        echo "1. po"
        echo "2. deploy"
        echo "3. hpa"
        echo "4. cm"

        read -p "select option" choice
        case $choice in
            1)
                kubenet "po"
                ;;
            2)
                kubenet "deploy"
                ;;
            3)
                kubenet "hpa"
                ;;
            4)
                kubenet "cm"
                ;;
            5)
                kubenet "ds"
                ;;
            6)
                kubenet "secrets"
                ;;
            7)
                kubenet "certificates"
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
        esac    
        select ns in "${namespace[@]}"; do
            pod="$(kubectl get $o1 -n $ns | awk 'NR>1 {print $1}')"
            IFS=$'\n' read -rd '' -a po <<<"$pod"
            select p in "${po[@]}"; do
                if [ ${#po[@]} -gt 0 ]; then
                    kubectl edit $o1 $po -n $ns
                else
                    echo "No resources found in $ns namespace."
                fi
                break
            done
        done
        elif [ "$o1" == "delete" ]; then
        echo "1. po"
        echo "2. deploy"
        echo "3. hpa"
        echo "4. cm"

        read -p "select option" choice
        case $choice in
            1)
                kubenet "po"
                ;;
            2)
                kubenet "deploy"
                ;;
            3)
                kubenet "hpa"
                ;;
            4)
                kubenet "cm"
                ;;
            5)
                kubenet "ds"
                ;;
            6)
                kubenet "secrets"
                ;;
            7)
                kubenet "certificates"
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
        esac    
        select ns in "${namespace[@]}"; do
            pod="$(kubectl get $o1 -n $ns | awk 'NR>1 {print $1}')"
            IFS=$'\n' read -rd '' -a po <<<"$pod"
            select p in "${po[@]}"; do
                if [ ${#po[@]} -gt 0 ]; then
                    kubectl delete $o1 $po -n $ns
                else
                    echo "No resources found in $ns namespace."
                fi
                break
            done
        done

    else
        echo "Nothing"
    fi

}

deployment() {
    o1=$1
    kube="$(kubectl get namespace | awk 'NR>1 {print $1}')"
    IFS=$'\n' read -rd '' -a namespace <<<"$kube"
    if [ "$o1" == "rollout restart" ]; then
        echo "1. deployment"
        echo "2. statefulset"
        echo "3. daemonset"
        echo "4. replicaset"
        echo "5. job"
        echo "6 cronjob"

        read -p "select option" choice
        case $choice in
            1)
                deployment "deployment"
                ;;
            2)
                deployment "statefulset"
                ;;
            3)
                deployment "daemonset"
                ;;
            4)
                deployment "replicaset"
                ;;
            5)
                deployment "ds"
                ;;
            6)
                deployment "secrets"
                ;;
            7)
                deployment "job"
                ;;
            8)
                deployment "cronjob"
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
        esac

        select ns in "${namespace[@]}"; do
            deploy="$(kubectl get $o1 -n $ns | awk 'NR>1 {print $1}')"
            IFS=$'\n' read -rd '' -a dep <<<"$deploy"
            if [ ${#dep[@]} -gt 0 ]; then
                select d in "${dep[@]}"; do
                    kubectl -n $ns rollout restart $o1 $d
                done
            else
                echo "No resources found in $ns namespace."
            fi
            break
        done
    elif [ "$o1" == "rollout status" ]; then
        echo "1. deployment"
        echo "2. statefulset"
        echo "3. daemonset"
        echo "4. replicaset"
        echo "5. job"
        echo "6 cronjob"

        read -p "select option" choice
        case $choice in
            1)
                deployment "deployment"
                ;;
            2)
                deployment "statefulset"
                ;;
            3)
                deployment "daemonset"
                ;;
            4)
                deployment "replicaset"
                ;;
            5)
                deployment "ds"
                ;;
            6)
                deployment "secrets"
                ;;
            7)
                deployment "job"
                ;;
            8)
                deployment "cronjob"
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
        esac

        select ns in "${namespace[@]}"; do
            deploy="$(kubectl get $o1 -n $ns | awk 'NR>1 {print $1}')"
            IFS=$'\n' read -rd '' -a dep <<<"$deploy"
            if [ ${#dep[@]} -gt 0 ]; then
                select d in "${dep[@]}"; do
                    kubectl -n $ns rollout status $o1 $d
                done
            else
                echo "No resources found in $ns namespace."
            fi
            break
        done
    elif [ "$o1" == "scale" ]; then
        echo "1. deployment"
        echo "2. statefulset"
        echo "3. daemonset"
        echo "4. replicaset"
        echo "5. job"
        echo "6 cronjob"

        read -p "select option" choice
        case $choice in
            1)
                deployment "deployment"
                ;;
            2)
                deployment "statefulset"
                ;;
            3)
                deployment "daemonset"
                ;;
            4)
                deployment "replicaset"
                ;;
            5)
                deployment "ds"
                ;;
            6)
                deployment "secrets"
                ;;
            7)
                deployment "job"
                ;;
            8)
                deployment "rc"
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
        esac

        select ns in "${namespace[@]}"; do
            deploy="$(kubectl get $o1 -n $ns | awk 'NR>1 {print $1}')"
            IFS=$'\n' read -rd '' -a dep <<<"$deploy"
            echo "Please enter your numbers of replica:"
            read replica
            if [ ${#dep[@]} -gt 0 ]; then
                select d in "${dep[@]}"; do
                    kubectl -n $ns scale $o1 $d --replicas=$replica
                done
            else
                echo "No resources found in $ns namespace."
            fi
            break
        done
    else
        echo "Nothing"
    fi
}

echo "1. Get"
echo "2. Logs"
echo "3. Describe"
echo "4. Nodes"
echo "5. Edit"
echo "6. Delete"
echo "7. Rollout Retart"
echo "8. Rollout Status"
echo "9. Scale"
echo "10 exit"

read -p "select option" choice

case $choice in
    1)
        kubenet "get"
        ;;
    2)
        kubenet "logs"
        ;;
    3)
        kubenet "des"
        ;;
    4)
        kubenet "nodes"
        ;;
    5)
        kubenet "edit"
        ;;
    6)
        kubenet "delete"
        ;;
    7)
        deployment "rollout restart"
        ;;
    8)
        deployment "rollout restart"
        ;;
    9)
        deployment "scale"
        ;;
    10)
        exit 0
        ;;
    *)
        echo "Invalid option. Please try again."
        ;;
esac    
