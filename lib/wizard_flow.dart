import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'state.dart';

class WizardFlow extends ConsumerStatefulWidget {
  const WizardFlow({super.key});
  @override
  ConsumerState<WizardFlow> createState() => _WizardFlowState();
}

class _WizardFlowState extends ConsumerState<WizardFlow> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _volumeCtrl = TextEditingController();
  String _water = "Rubinetto";
  String _substrate = "Fondo fertile a granuli";
  String _lighting = "LED 8h/d";
  DateTime _startDate = DateTime.now();

  int step = 0;

  void next(){
    if (step == 0) {
      if (_formKey.currentState?.validate() ?? false) setState(()=> step++);
    } else if (step < 4) {
      setState(()=> step++);
    } else {
      final setup = TankSetup(
        tankName: _nameCtrl.text.trim().isEmpty ? "La mia vasca" : _nameCtrl.text.trim(),
        volumeLiters: int.tryParse(_volumeCtrl.text) ?? 60,
        waterType: _water,
        substrate: _substrate,
        lighting: _lighting,
        startDate: _startDate,
      );
      ref.read(setupProvider.notifier).set(setup);
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void back(){ if(step>0) setState(()=> step--); }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _StepCard(title: "Informazioni vasca", child: _tankForm()),
      _StepCard(title: "Tipo d'acqua", child: _waterPicker()),
      _StepCard(title: "Illuminazione", child: _lightPicker()),
      _StepCard(title: "Substrato", child: _substratePicker()),
      _StepCard(title: "Data di avvio", child: _datePicker()),
    ];

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text("Setup iniziale")),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: pages[step],
              )),
              Row(
                children: [
                  if (step>0) CupertinoButton(child: const Text("Indietro"), onPressed: back),
                  const Spacer(),
                  CupertinoButton.filled(child: Text(step<4 ? "Avanti" : "Conferma"), onPressed: next),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _tankForm(){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CupertinoTextFormFieldRow(
            controller: _nameCtrl,
            placeholder: "Nome vasca (es. Laghetto 60L)",
            validator: (_) => null,
          ),
          CupertinoTextFormFieldRow(
            controller: _volumeCtrl,
            keyboardType: TextInputType.number,
            placeholder: "Volume (L) es. 60",
            validator: (v){
              final n = int.tryParse(v ?? "");
              if (n == null || n <= 0) return "Inserisci un numero valido";
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _segmented<T>(T value, List<T> values, String Function(T) label, void Function(T) onChanged){
    return CupertinoSegmentedControl<T>(
      groupValue: value,
      children: {for(final v in values) v: Padding(padding: const EdgeInsets.all(8), child: Text(label(v)))},
      onValueChanged: onChanged,
    );
  }

  Widget _waterPicker(){
    return Column(
      children: [
        const Text("Che acqua userai?"),
        const SizedBox(height: 12),
        _segmented<String>(_water, const ["Rubinetto","Osmosi"], (v)=>v, (v)=>setState(()=>_water=v)),
        const SizedBox(height: 12),
        Text(_water=="Rubinetto"
            ? "Ricorda il biocondizionatore e verifica GH/KH del tuo rubinetto."
            : "Con l’osmosi remineralizza fino ai valori target della tua fauna."),
      ],
    );
  }

  Widget _lightPicker(){
    return Column(
      children: [
        const Text("Imposta fotoperiodo"),
        const SizedBox(height: 12),
        _segmented<String>(_lighting, const ["LED 6h/d","LED 8h/d","LED 10h/d"], (v)=>v, (v)=>setState(()=>_lighting=v)),
        const SizedBox(height: 12),
        const Text("In avviamento 6–8 ore/die è consigliato per contenere alghe."),
      ],
    );
  }

  Widget _substratePicker(){
    return Column(
      children: [
        const Text("Scegli substrato"),
        const SizedBox(height: 12),
        _segmented<String>(_substrate, const ["Fondo fertile a granuli","Inerte + tabs","Tecnico"], (v)=>v, (v)=>setState(()=>_substrate=v)),
        const SizedBox(height: 12),
        const Text("Il fondo fertile aiuta le piante esigenti; l’inerte è più semplice."),
      ],
    );
  }

  Widget _datePicker(){
    return Column(
      children: [
        const Text("Data di avvio"),
        const SizedBox(height: 12),
        CupertinoButton(
          child: Text("${_startDate.day}/${_startDate.month}/${_startDate.year}"),
          onPressed: () async {
            await showCupertinoModalPopup(context: context, builder: (_){
              return Container(
                color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                height: 260,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _startDate,
                  onDateTimeChanged: (d)=> setState(()=> _startDate = d),
                ),
              );
            });
          },
        ),
        const SizedBox(height: 8),
        const Text("La useremo per calcolare le tappe (pulitori, pesci, manutenzione)."),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _StepCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: CupertinoTheme.of(context).barBackgroundColor?.withOpacity(0.5),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0x33FFFFFF)),
          ),
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ],
    );
  }
}