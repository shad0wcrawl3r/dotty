use udev::Enumerator;

#[tokio::main]
async fn main() {
    let mut enumerator = Enumerator::new().unwrap();
    enumerator.match_subsystem("power_supply").unwrap();
    let mut monitor = udev::MonitorBuilder::new()
        .unwrap()
        .match_subsystem("power_supply")
        .unwrap()
        .listen()
        .unwrap();
    loop {
        match monitor.iter().next() {
            Some(event) => println!("{event:?}"),
            None => {}
        }
    }
}
