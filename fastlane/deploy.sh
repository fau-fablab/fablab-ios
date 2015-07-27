if [ -f "../fablab.ipa" ]
then
  echo "Uploading ipa"
  scp ../FAU\ FabLab.ipa mad:/var/www/hockey/public/de.fau.cs.mad.fablab.ios/fablab.ipa
else
  echo "Ipa file not found! :-("
fi

