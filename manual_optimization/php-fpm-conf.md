# Optimisasi PHP FPM
```conf
pm = dynamic
pm.max_children = 32
pm.start_servers = 4
pm.min_spare_servers = 2
pm.max_spare_servers = 16
```

##### max_children
adalah jumlah maksimal proses yang dapat berjalan dan dapat di aktivasi oleh PHP FPM

##### max_spare_server
adalah jumlah maksimal proses php fpm yang stand by, proses ini akan berkurang jika beberapa proses tidak di perlukan, sampai pada batas minimal pada server (min_spare_server)


## Case Studdies
Pada situs yang cukup High Traffic maka bisa di tingkatkan parameter di atas.
