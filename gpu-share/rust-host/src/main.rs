use vulkano::instance::{Instance, InstanceCreateInfo};
use vulkano::library::VulkanLibrary;
use serde_json::json;

fn vendor_name(vendor_id: u32) -> &'static str {
    match vendor_id {
        0x10DE => "NVIDIA",
        0x1002 => "AMD",
        0x8086 => "Intel",
        _ => "Unknown",
    }
}

fn gpu_type(name: &str, vendor: &str) -> &'static str {
    if name.to_lowercase().contains("llvmpipe") {
        return "software";
    }

    match vendor {
        "NVIDIA" | "AMD" => "discrete",
        "Intel" => "integrated",
        _ => "unknown",
    }
}

fn usable_for_compute(name: &str) -> bool {
    let n = name.to_lowercase();

    if n.contains("llvmpipe") {
        return false;
    }

    true
}

fn main() {
    let library = VulkanLibrary::new().expect("No Vulkan support");

    let instance = Instance::new(
        library,
        InstanceCreateInfo::default(),
    ).expect("Failed to create instance");

    let mut output = vec![];

    for device in instance.enumerate_physical_devices().unwrap() {
        let props = device.properties();

        let name = props.device_name.clone();
        let vendor = vendor_name(props.vendor_id);

        let vram_mb = device
            .memory_properties()
            .memory_heaps
            .iter()
            .map(|h| h.size as u64 / 1024 / 1024)
            .max()
            .unwrap_or(0);

        let gpu = json!({
            "name": name,
            "vendor": vendor,
            "vendor_id": props.vendor_id,
            "device_id": props.device_id,
            "vram_mb": vram_mb,

            "type": gpu_type(&name, vendor),
            "usable_for_compute": usable_for_compute(&name)
        });

        output.push(gpu);
    }

    println!("{}", serde_json::to_string_pretty(&output).unwrap());
}