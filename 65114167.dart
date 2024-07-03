import 'dart:io';

class MenuItem {
  String name;
  double price;
  String category;

  MenuItem({required this.name, required this.price, required this.category});

  @override
  String toString() {
    return "MenuItem(name: $name, price: $price, category: $category)";
  }
}

class Order {
  String orderId;
  int tableNumber;
  List<MenuItem> items;
  bool isCompleted;

  Order({
    required this.orderId,
    required this.tableNumber,
    this.items = const [],
    this.isCompleted = false,
  });

  void addItem(MenuItem item) {
    items.add(item);
  }

  void removeItem(MenuItem item) {
    items.remove(item);
  }

  void completeOrder() {
    isCompleted = true;
  }

  @override
  String toString() {
    return "Order(orderId: $orderId, tableNumber: $tableNumber, items: $items, isCompleted: $isCompleted)";
  }
}

class Restaurant {
  List<MenuItem> menu;
  List<Order> orders;
  Map<int, bool> tables;

  Restaurant({
    List<MenuItem> menu = const [],
    List<Order> orders = const [],
    Map<int, bool> tables = const {},
  }) : menu = List.from(menu), orders = List.from(orders), tables = Map.from(tables);

  void addMenuItem(MenuItem item) {
    menu.add(item);
  }

  void removeMenuItem(MenuItem item) {
    menu.remove(item);
  }

  void placeOrder(Order order) {
    orders.add(order);
  }

  void completeOrder(String orderId) {
    for (Order order in orders) {
      if (order.orderId == orderId) {
        order.completeOrder();
        break;
      }
    }
  }

  MenuItem? getMenuItem(String name) {
    for (MenuItem item in menu) {
      if (item.name == name) {
        return item;
      }
    }
    return null;
  }

  Order? getOrder(String orderId) {
    for (Order order in orders) {
      if (order.orderId == orderId) {
        return order;
      }
    }
    return null;
  }

  void displayMenu() {
    print("\n----------Menu----------");
    for (MenuItem item in menu) {
      print("${item.name} - ${item.price}฿ (${item.category})");
    }
    print("--------------------------");
  }

  void displayOrders() {
    print("\n----------Orders----------");
    for (Order order in orders) {
      print("${order.orderId}: Table ${order.tableNumber} - Items: ${order.items.length} - Completed: ${order.isCompleted}");
    }
    print("---------------------------");
  }

  void displayTables() {
    print("\n----------Tables----------");
    tables.forEach((tableNumber, isOccupied) {
      print("Table $tableNumber: ${isOccupied ? 'Occupied' : 'Available'}");
    });
    print("---------------------------");
  }

  void updateMenuItem(String name, double price, String category) {
    for (MenuItem item in menu) {
      if (item.name == name) {
        item.price = price;
        item.category = category;
        break;
      }
    }
  }

  void deleteMenuItem(String name) {
    menu.removeWhere((item) => item.name == name);
  }

  void deleteOrder(String orderId) {
    orders.removeWhere((order) => order.orderId == orderId);
  }
}

void main() {
  var restaurant = Restaurant();

  // Adding sample data for demonstration
  restaurant.addMenuItem(MenuItem(name: "Pad Thai", price: 50.0, category: "Main Dish"));
  restaurant.addMenuItem(MenuItem(name: "Tom Yum Soup", price: 40.0, category: "Soup"));

  restaurant.tables = {1: false, 2: true, 3: false}; // Sample tables with initial occupancy

  while (true) {
    print("\n-----Restaurant Management System-----");
    print("1. Display Menu");
    print("2. Display Orders");
    print("3. Display Tables");
    print("4. Add Menu Item");
    print("5. Update Menu Item");
    print("6. Delete Menu Item");
    print("7. Delete Order");
    print("8. Exit");
    print("----------------------------------------");
    stdout.write("\x1B[32mSelect option: \x1B[0m"); // Green color for prompt
    var optionInput = stdin.readLineSync();
    if (optionInput == null) {
      print("\x1B[31mInvalid input. Please enter a valid option.\x1B[0m"); // Red color for error message
      continue;
    }
    var option = int.tryParse(optionInput);
    if (option == null || option < 1 || option > 8) {
      print("\x1B[31mInvalid option. Please enter a number between 1 and 8.\x1B[0m"); // Red color for error message
      continue;
    }

    switch (option) {
      case 1:
        restaurant.displayMenu();
        break;
      case 2:
        restaurant.displayOrders();
        break;
      case 3:
        restaurant.displayTables();
        break;
      case 4:
        addMenuItemScreen(restaurant);
        break;
      case 5:
        updateMenuItemScreen(restaurant);
        break;
      case 6:
        deleteMenuItemScreen(restaurant);
        break;
      case 7:
        deleteOrderScreen(restaurant);
        break;
      case 8:
        print("\x1B[34mExiting...\x1B[0m"); // Blue color for exit message
        return;
    }
  }
}

void addMenuItemScreen(Restaurant restaurant) {
  print("\nAdding a New Menu Item");
  stdout.write("Enter item name: ");
  var name = stdin.readLineSync();
  if (name == null || name.isEmpty) {
    print("Invalid name. Please enter a valid name.");
    return;
  }

  stdout.write("Enter item price: ");
  var priceInput = stdin.readLineSync();
  var price = double.tryParse(priceInput ?? '');
  if (price == null) {
    print("Invalid price. Please enter a valid number.");
    return;
  }

  stdout.write("Enter item category (Main Dish, Dessert, Beverage): ");
  var category = stdin.readLineSync();
  if (category == null || category.isEmpty) {
    print("Invalid category. Please enter a valid category.");
    return;
  }

  var newItem = MenuItem(name: name, price: price, category: category);
  restaurant.addMenuItem(newItem);
  print("Menu item added: $newItem");
}

void updateMenuItemScreen(Restaurant restaurant) {
  print("\nUpdating a Menu Item");
  stdout.write("Enter item name to update: ");
  var name = stdin.readLineSync();
  if (name == null || name.isEmpty) {
    print("Invalid name. Please enter a valid name.");
    return;
  }

  stdout.write("Enter new price: ");
  var priceInput = stdin.readLineSync();
  var price = double.tryParse(priceInput ?? '');
  if (price == null) {
    print("Invalid price. Please enter a valid number.");
    return;
  }

  stdout.write("Enter new category (Main Dish, Dessert, Beverage): ");
  var category = stdin.readLineSync();
  if (category == null || category.isEmpty) {
    print("Invalid category. Please enter a valid category.");
    return;
  }

  restaurant.updateMenuItem(name, price, category);
  print("Menu item updated.");
}

void deleteMenuItemScreen(Restaurant restaurant) {
  print("\nDeleting a Menu Item");
  stdout.write("Enter item name to delete: ");
  var name = stdin.readLineSync();
  if (name == null || name.isEmpty) {
    print("Invalid name. Please enter a valid name.");
    return;
  }

  restaurant.deleteMenuItem(name);
  print("Menu item deleted.");
}

void deleteOrderScreen(Restaurant restaurant) {
  print("\nDeleting an Order");
  stdout.write("Enter order ID to delete: ");
  var orderId = stdin.readLineSync();
  if (orderId == null || orderId.isEmpty) {
    print("Invalid order ID. Please enter a valid ID.");
    return;
  }

  restaurant.deleteOrder(orderId);
  print("Order deleted.");
}
