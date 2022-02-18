import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_switch/sliding_switch.dart';

enum PizzaDough { defaultDough, liteDough }

enum Sauces { spicy, sweetAndSour, cheese }

class PizzaModel extends ChangeNotifier {
  PizzaDough dough = PizzaDough.defaultDough;
  double size = 27;
  Sauces sauce = Sauces.spicy;
  bool cheese = false;

  void updatePriceText() {
    var price = pizzaPrice();
    notifyListeners();
  }

  List<double> pizzaSizes() => [27, 30, 33, 36];

  int pizzaPrice() {
    var price = 200; //начальная цена

    if (dough == PizzaDough.liteDough) price += 20;

    if (size == 30) {
      price += 30;
    } else if (size == 33) {
      price += 60;
    } else if (size == 36) {
      price = price + 90;
    }

    if (sauce == Sauces.spicy) {
      price += 30;
    } else if (sauce == Sauces.sweetAndSour) {
      price += 40;
    } else if (sauce == Sauces.cheese) {
      price += 35;
    }

    if (cheese) price += 20;

    return price;
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const _PizzaStfWidget(),
    );
  }
}

class _PizzaStfWidget extends StatefulWidget {
  const _PizzaStfWidget({Key? key}) : super(key: key);

  @override
  _PizzaStfWidgetState createState() => _PizzaStfWidgetState();
}

class _PizzaStfWidgetState extends State<_PizzaStfWidget> {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => PizzaModel(),
    child: const _PizzaCalculateWidget(),
  );
}

class _PizzaCalculateWidget extends StatelessWidget {
  const _PizzaCalculateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final modelPizza = context.read<PizzaModel>();
    return Scaffold(
      body: ListView(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            _PizzaImageWidget(),
            SizedBox(height: 33),
            _PizzaTextCalculateWidget(),
            SizedBox(height: 9),
            _PizzaTextSelectParametersWidget(),
            SizedBox(height: 40),
            _PizzaSwitchDoughWidget(),
            SizedBox(height: 19),
            _PizzaTextSizeWidget(),
            _PizzaSizeSliderWidget(),
            _PizzaTextSauceWidget(),
            _PizzaSauceRadioButtonWidget(),
            _PizzaExtraCheeseWidget(),
            SizedBox(height: 10),
            _PizzaTextPriceWidget(),
            _PizzaPriceTextFieldWidget(),
            SizedBox(height: 10),
            _PizzaOrderButtonWidget(),
          ],
        ),
      ]),
    );
  }
}

class _PizzaImageWidget extends StatelessWidget {
  const _PizzaImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      child: const SizedBox(
        width: 232,
        height: 123,
        child: Image(
          image: AssetImage('assets/img.png'),
        ),
      ),
    );
  }
}

class _PizzaTextCalculateWidget extends StatelessWidget {
  const _PizzaTextCalculateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Калькулятор пиццы',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
      textAlign: TextAlign.center,
    );
  }
}

class _PizzaTextSelectParametersWidget extends StatelessWidget {
  const _PizzaTextSelectParametersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Выберите параметры:',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      textAlign: TextAlign.center,
    );
  }
}

class _PizzaSwitchDoughWidget extends StatelessWidget {
  const _PizzaSwitchDoughWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pizzaModel = context.watch<PizzaModel>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SlidingSwitch(
          value: false,
          textOff: 'Обычное тесто',
          textOn: 'Тонкое тесто',
          width: 350,
          height: 38,
          colorOn: Colors.white,
          colorOff: Colors.white,
          buttonColor: Colors.blue,
          inactiveColor: Colors.grey,
          onChanged: (value) {
            pizzaModel.dough =
            value ? PizzaDough.liteDough : PizzaDough.defaultDough;
            pizzaModel.updatePriceText();
          },
          onTap: (value) {},
          onDoubleTap: (value) {},
          onSwipe: (value) {}),
    );
  }
}

class _PizzaTextSizeWidget extends StatelessWidget {
  const _PizzaTextSizeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: const Text(
        'Размер:',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        textAlign: TextAlign.start,
      ),
    );
  }
}

class _PizzaSizeSliderWidget extends StatelessWidget {
  const _PizzaSizeSliderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final pizzaModel = context.watch<PizzaModel>();
    var _val = pizzaModel.size;
    TextEditingController textEditController = TextEditingController();
    String textSize = '${pizzaModel.size.toInt()} см.';
    textEditController.text = textSize;
    const textFieldDecoration = InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 5),

    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(
            width: 350,
            child: TextField(
              style: const TextStyle(fontWeight: FontWeight.w600),
              controller: textEditController,
              decoration: textFieldDecoration,
              textAlign: TextAlign.center,
              readOnly: true,
            ),
          ),
          Slider(
            min: pizzaModel.pizzaSizes().first,
            max: pizzaModel.pizzaSizes().last,
            value: _val,
            divisions: 3,
            label: _val.round().toString(),
            onChanged: (double value) {
              _val = value;
              pizzaModel.size = _val;
              pizzaModel.updatePriceText();
            },
          ),
        ],
      ),
    );
  }
}

class _PizzaTextSauceWidget extends StatelessWidget {
  const _PizzaTextSauceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: const Text(
        'Соус:',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        textAlign: TextAlign.start,
      ),
    );
  }
}

class _PizzaSauceRadioButtonWidget extends StatefulWidget {
  const _PizzaSauceRadioButtonWidget({Key? key}) : super(key: key);

  @override
  State<_PizzaSauceRadioButtonWidget> createState() =>
      _PizzaSauceRadioButtonWidgetState();
}

class _PizzaSauceRadioButtonWidgetState
    extends State<_PizzaSauceRadioButtonWidget> {
  TextStyle textStyle =
  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    final pizzaModel = context.watch<PizzaModel>();
    Sauces? _value = pizzaModel.sauce;

    void _onChangedRadoButton(Sauces? value) {
      _value = value;
      pizzaModel.sauce = value!;
      pizzaModel.updatePriceText();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          RadioListTile<Sauces>(
            title: Text(
              'Острый',
              style: textStyle,
            ),
            value: Sauces.spicy,
            groupValue: _value,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            onChanged: (Sauces? value) => _onChangedRadoButton(value),
          ),
          const Divider(color: Colors.black),
          RadioListTile<Sauces>(
            title: Text(
              'Кисло-сладкий',
              style: textStyle,
            ),
            value: Sauces.sweetAndSour,
            groupValue: _value,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            onChanged: (Sauces? value) => _onChangedRadoButton(value),
          ),
          const Divider(color: Colors.black),
          RadioListTile<Sauces>(
            title: Text(
              'Сырный',
              style: textStyle,
            ),
            value: Sauces.cheese,
            groupValue: _value,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            onChanged: (Sauces? value) => _onChangedRadoButton(value),
          ),
          const Divider(color: Colors.black),
        ],
      ),
    );
  }
}

class _PizzaExtraCheeseWidget extends StatefulWidget {
  const _PizzaExtraCheeseWidget({Key? key}) : super(key: key);

  @override
  State<_PizzaExtraCheeseWidget> createState() =>
      _PizzaExtraCheeseWidgetState();
}

class _PizzaExtraCheeseWidgetState extends State<_PizzaExtraCheeseWidget> {
  TextStyle textStyle =
  const TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
  @override
  Widget build(BuildContext context) {
    final pizzaModel = context.watch<PizzaModel>();
    bool _val = pizzaModel.cheese;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: const Color(0xFFECEFF1),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 6),
          const SizedBox(
            width: 34,
            height: 36,
            child: Image(
              image: AssetImage('assets/img_1.png'),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
              child: Text(
                'Дополнительный сыр',
                style: textStyle,
              )),
          Switch(
            //title: const Text('Дополнительный сыр'),
              value: _val,
              onChanged: (value) {
                _val = !_val;
                pizzaModel.cheese = _val;
                pizzaModel.updatePriceText();
              }),
        ],
      ),
    );
  }
}

class _PizzaTextPriceWidget extends StatelessWidget {
  const _PizzaTextPriceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: const Text(
        'Стоимость:',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        textAlign: TextAlign.start,
      ),
    );
  }
}

class _PizzaPriceTextFieldWidget extends StatelessWidget {
  const _PizzaPriceTextFieldWidget({Key? key}) : super(key: key);

  final textFieldDecoration = const InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 5));

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditController = TextEditingController();
    var pizzaModel = context.watch<PizzaModel>();
    String textPrice = '${pizzaModel.pizzaPrice().toString()} руб.';
    textEditController.text = textPrice;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(

        style: const TextStyle(fontWeight: FontWeight.w600),
        controller: textEditController,
        decoration: textFieldDecoration,
        textAlign: TextAlign.center,
        readOnly: true,
      ),
    );
  }
}

class _PizzaOrderButtonWidget extends StatelessWidget {
  const _PizzaOrderButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ButtonStyle _buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.blue),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
    );
    TextStyle _textStyle = const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white);

    return ElevatedButton(
      style: _buttonStyle,
      onPressed: () {},
      child: Text(
        'Заказать',
        style: _textStyle,
      ),
    );
  }
}
