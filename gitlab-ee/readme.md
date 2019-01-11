#手动创建本地卷
#手动创建pv
#手动创建storageclass
#pod  绑定storageclass
#kind: StatefulSet
#...
# volumeClaimTemplates:
#  - metadata:
#      name: example-local-claim
#    spec:
#      accessModes:
#      - ReadWriteOnce
#      storageClassName: local-storage
#      resources:
#        requests:
#          storage: 500Gi
#需要手动清理pv

