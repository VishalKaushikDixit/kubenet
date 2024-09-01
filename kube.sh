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
                kubectl get po -n $ns
                select p in "${po[@]}"; do
                    kubectl -n $ns logs -f $p
                done
            else
                echo "No resources found in $ns namespace."
            fi
            break
        done
    elif [ "$o1" == "des" ]; then
        select ns in "${namespace[@]}"; do
            pod="$(kubectl get po -n $ns | awk 'NR>1 {print $1}')"
            IFS=$'\n' read -rd '' -a po <<<"$pod"
            if [ ${#po[@]} -gt 0 ]; then
                kubectl get po -n $ns
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
            *)
                echo "Invalid option. Please try again."
                ;;
        esac    
        select ns in "${namespace[@]}"; do
            pod="$(kubectl get po -n $ns | awk 'NR>1 {print $1}')"
            IFS=$'\n' read -rd '' -a po <<<"$pod"
            if [ ${#po[@]} -gt 0 ]; then
                kubectl get $o1 -n $ns
            else
                echo "No resources found in $ns namespace."
            fi
            break
        done
    else
        echo "Nothing"
    fi

}

echo "1. get"
echo "2. logs"
echo "3. describe po"
echo "4. Exit"

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
        exit 0
        ;;
    *)
        echo "Invalid option. Please try again."
        ;;
esac    



