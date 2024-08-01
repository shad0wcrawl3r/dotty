use std::{fs, path::Path};
use udev::Enumerator;
#[tokio::main]
async fn main() {
    let mut enumerator = Enumerator::new().unwrap();
    enumerator.match_subsystem("power_supply").unwrap();
    let monitor = udev::MonitorBuilder::new()
        .unwrap()
        .match_subsystem("power_supply")
        .unwrap()
        .listen()
        .unwrap();
    loop {
        match monitor.iter().next() {
            Some(event) => {
                let dev_type = event.subsystem().unwrap();
                println!("{:?}", event.syspath());
                if dev_type != "power_supply" || !(event.syspath().ends_with("AC0")) {
                    continue;
                }
                let dev_path = Path::new(event.syspath());
                let path_to_eval = dev_path.join("online");
                if path_to_eval.exists() {
                    let data = fs::read_to_string(path_to_eval).expect("0");
                    println!("{data}")
                }
                //from_str(format!("{:?}/online", path)) {}
            }
            None => {}
        }
    }
}

// Event { device: Device { initialized: true, device_major_minor_number: None, system_path: "/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2c/PNP0C09:00/ACPI0003:00/power_supply/AC0", device_path: "/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2c/PNP0C09:00/ACPI0003:00/power_supply/AC0", device_node: None, subsystem_name: Some("power_supply"), system_name: "AC0", instance_number: Some(0), device_type: None, driver: None, action: Some("change"), parent: Some(Device { initialized: true, device_major_minor_number: None, system_path: "/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2c/PNP0C09:00/ACPI0003:00", device_path: "/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2c/PNP0C09:00/ACPI0003:00", device_node: None, subsystem_name: Some("acpi"), system_name: "ACPI0003:00", instance_number: Some(0), device_type: None, driver: Some("ac"), action: None, parent: Some(Device { initialized: true, device_major_minor_number: None, system_path: "/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2c/PNP0C09:00", device_path: "/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2c/PNP0C09:00", device_node: None, subsystem_name: Some("acpi"), system_name: "PNP0C09:00", instance_number: Some(0), device_type: None, driver: Some("ec"), action: None, parent: Some(Device { initialized: true, device_major_minor_number: None, system_path: "/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2c", device_path: "/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2c", device_node: None, subsystem_name: Some("acpi"), system_name: "device:2c", instance_number: None, device_type: None, driver: None, action: None, parent: Some(Device { initialized: true, device_major_minor_number: None, system_path: "/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00", device_path: "/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00", device_node: None, subsystem_name: Some("acpi"), system_name: "PNP0A08:00", instance_number: Some(0), device_type: None, driver: None, action: None, parent: Some(Device { initialized: true, device_major_minor_number: None, system_path: "/sys/devices/LNXSYSTM:00/LNXSYBUS:00", device_path: "/devices/LNXSYSTM:00/LNXSYBUS:00", device_node: None, subsystem_name: Some("acpi"), system_name: "LNXSYBUS:00", instance_number: Some(0), device_type: None, driver: None, action: None, parent: Some(Device { initialized: true, device_major_minor_number: None, system_path: "/sys/devices/LNXSYSTM:00", device_path: "/devices/LNXSYSTM:00", device_node: None, subsystem_name: Some("acpi"), system_name: "LNXSYSTM:00", instance_number: Some(0), device_type: None, driver: None, action: None, parent: None }) }) }) }) }) }) }, event_type: Change, sequence_number: 3500 }
