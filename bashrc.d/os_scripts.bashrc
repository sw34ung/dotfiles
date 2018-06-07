osc_vmshow () {

if [ -z "$1" ];then
  echo "Invalid id $1"
  exit 0
fi

getinput=$1

if [[ $getinput =~ ^\{?[A-F0-9a-f]{8}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{12}\}?$ ]]; then
        vmid=$getinput
fi

if [[ $getinput =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        vmid=`openstack port list --fixed-ip ip-address=$getinput -f value -c ID |xargs -n1 openstack port show -f value -c device_id`
fi

function openstack_server_show() {
echo VM ID is "$vmid"
#openstack server show $vmid -c addresses -c name -c project_id -c user_id -c status -c id -c created -c updated -c OS-EXT-SRV-ATTR:hypervisor_hostname -c flavor -c image -c security_groups -c key_name -c volumes_attached
openstack server show $vmid

}

function security_rule_list() {
        for i in `nova list-secgroup $vmid | grep -vE '(Id|\+)' | awk '{print $2"("$4")"}'`;do echo Securty Group: $i;openstack security group rule list --long `echo $i|awk -F"(" '{print $1}'`;done
}

openstack_server_show
security_rule_list

# END
}
