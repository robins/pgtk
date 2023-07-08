BINDIR='/home/ubuntu/proj/tempdel/bin'
WALDIR='/home/ubuntu/proj/tempdel/data/pg_wal'
WALTXTDIR='/home/ubuntu/proj/tempdel/waltxt'

echo "Intentionally hiding any pg_waldump errors"

for wal1 in $(ls ${WALDIR}/0000* | grep -v done |  xargs -i basename {} )
do
  echo -n ${wal1}

  if [ -s ${WALTXTDIR}/waldump_${wal1}.txt ]; then
    echo ".. Skipped"
    continue
  elif [ -f ${WALTXTDIR}/waldump_${wal1}.txt ]; then
    echo -n ".. reprocesssing empty file"
  fi

  ${BINDIR}/pg_waldump ${WALDIR}/${wal1} 2>/dev/null | sed -e "s/^/${wal1} /g" > ${WALTXTDIR}/waldump_${wal1}.txt
  echo ".. Done"
  sleep 0.1
done