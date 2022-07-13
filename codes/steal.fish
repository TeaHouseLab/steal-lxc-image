function steal
    init
    set image (curl -sL $mirror/lxc-images/streams/v1/images.json | jq -r '.products')
    rm built/*
    for target in (echo $image | jq -r 'keys|.[]')
        if test $logger = "debug"
            logger 3 "target -> $target"
        end
        set os (echo $image | jq -r ".[\"$target\"].os" | tr '[:upper:]' '[:lower:]')
        if test $logger = "debug"
            logger 3 "os -> $os"
        end
        set release (echo $image | jq -r ".[\"$target\"].release" | tr '[:upper:]' '[:lower:]')
        if test $logger = "debug"
            logger 3 "release -> $release"
        end
        set arch (echo $image | jq -r ".[\"$target\"].arch" | tr '[:upper:]' '[:lower:]')
        if test $logger = "debug"
            logger 3 "arch -> $arch"
        end
        set variant (echo $image | jq -r ".[\"$target\"].variant" | tr '[:upper:]' '[:lower:]')
        if test $logger = "debug"
            logger 3 "variant -> $variant"
        end
        set latest (echo $image | jq -r ".[\"$target\"].versions|keys|.[]" | tail -n1)
        if test $logger = "debug"
            logger 3 "build_date -> $latest"
        end
        set path (echo $image | jq -r ".[\"$target\"].versions|.[\"$latest\"].items |.[\"root.tar.xz\"].path")
        if test $logger = "debug"
            logger 3 "download_path -> $path"
        end
        aria2c -x16 -s16 -k1M -d ./built -o $os-$release-$arch-$variant $mirror/lxc-images/$path
        echo "$os-$release-$arch-$variant $(ls -sh built/$os-$release-$arch-$variant | awk -F' ' '{print $1}')" >>built/available
    end
end
