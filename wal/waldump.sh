# Uses pg_waldump to process all WALs into Text files (1:1 mapping)
#
# Sample Output
# -------------
# $ ./dumpwals.sh
# 000000010000000000000005.. Skipped
# 000000010000000000000006.. reprocesssing empty file.. Done
# 000000010000000000000007.. reprocesssing empty file.. Done
# 000000010000000000000008.. reprocesssing empty file.. Done
# 000000010000000000000009.. Done


BINDIR='/home/ubuntu/proj/tempdel/bin'
WALDIR='/home/ubuntu/proj/tempdel/data/pg_wal'
WALTXTDIR='/home/ubuntu/proj/tempdel/waltxt'

for wal1 in $(ls ${WALDIR}/0000* | grep -v done |  xargs -i basename {} )
do
  echo -n ${wal1}

  if [ -s ${WALTXTDIR}/waldump_${wal1}.txt ]; then
    echo ".. Skipped"
    continue
  elif [ -f ${WALTXTDIR}/waldump_${wal1}.txt ]; then
    echo -n ".. reprocesssing empty file"
  fi

  # Intentionally hiding any pg_waldump errors
  ${BINDIR}/pg_waldump ${WALDIR}/${wal1} 2>/dev/null | sed -e "s/^/${wal1} /g" > ${WALTXTDIR}/waldump_${wal1}.txt
  echo ".. Done"
  
done
