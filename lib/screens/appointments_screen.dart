import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _upcomingAppointments = [
    {
      'doctor': 'Dr. Aminata Diallo',
      'specialty': 'Pédiatre',
      'date': '28/09/2026',
      'time': '10:30',
      'location': 'Hôpital Fann, Dakar',
      'status': 'Confirmé',
    },
    {
      'doctor': 'Dr. Ousmane Ndiaye',
      'specialty': 'Généraliste',
      'date': '01/10/2026',
      'time': '15:00',
      'location': 'Clinique Madeleine, Dakar',
      'status': 'En attente',
    },
  ];

  final List<Map<String, dynamic>> _pastAppointments = [
    {
      'doctor': 'Dr. Cheikh Sow',
      'specialty': 'Dentiste',
      'date': '14/08/2026',
      'time': '09:00',
      'location': 'Centre de Santé, Plateau',
      'status': 'Terminé',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showNewAppointmentModal() {
    final formKey = GlobalKey<FormState>();
    final doctorController = TextEditingController();
    final specialtyController = TextEditingController();
    final locationController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 24,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Nouveau Rendez-vous',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: AppColors.textSecondary),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: doctorController,
                        decoration: const InputDecoration(
                          labelText: 'Médecin',
                          prefixIcon: Icon(Icons.person_outline, color: AppColors.primaryGradientStart),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                        v == null || v.isEmpty ? 'Nom requis' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: specialtyController,
                        decoration: const InputDecoration(
                          labelText: 'Spécialité (ex: Généraliste)',
                          prefixIcon: Icon(Icons.medical_services_outlined, color: AppColors.primaryGradientStart),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                        v == null || v.isEmpty ? 'Spécialité requise' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: locationController,
                        decoration: const InputDecoration(
                          labelText: 'Lieu / Structure de santé',
                          prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.primaryGradientStart),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                        v == null || v.isEmpty ? 'Lieu requis' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primaryGradientStart,
                                side: BorderSide(color: AppColors.primaryGradientStart.withAlpha(100)),
                              ),
                              icon: const Icon(Icons.calendar_month),
                              label: Text(
                                selectedDate == null
                                    ? 'Date'
                                    : '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}',
                              ),
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (date != null) {
                                  setModalState(() => selectedDate = date);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primaryGradientStart,
                                side: BorderSide(color: AppColors.primaryGradientStart.withAlpha(100)),
                              ),
                              icon: const Icon(Icons.access_time),
                              label: Text(
                                selectedTime == null
                                    ? 'Heure'
                                    : selectedTime!.format(context),
                              ),
                              onPressed: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (time != null) {
                                  setModalState(() => selectedTime = time);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGradientStart,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (selectedDate == null || selectedTime == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Veuillez sélectionner une date et une heure'),
                                  ),
                                );
                                return;
                              }

                              setState(() {
                                _upcomingAppointments.insert(0, {
                                  'doctor': doctorController.text,
                                  'specialty': specialtyController.text,
                                  'date':
                                  '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}',
                                  'time': selectedTime!.format(context),
                                  'location': locationController.text,
                                  'status': 'En attente',
                                });
                              });

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Rendez-vous ajouté avec succès !'),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Enregistrer le rdv',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rendez-vous',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryGradientStart,
          labelColor: AppColors.primaryGradientStart,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'À venir'),
            Tab(text: 'Historique'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentList(_upcomingAppointments, isUpcoming: true),
          _buildAppointmentList(_pastAppointments, isUpcoming: false),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showNewAppointmentModal,
        backgroundColor: AppColors.primaryGradientStart,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Nouveau rdv',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildAppointmentList(List<Map<String, dynamic>> appointments,
      {required bool isUpcoming}) {
    if (appointments.isEmpty) {
      return const Center(
        child: Text(
          'Aucun rendez-vous trouvé',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final item = appointments[index];
        return Card(
          elevation: 0,
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.cardBorder.withAlpha(80)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                            AppColors.primaryGradientStart.withAlpha(20),
                            child: const Icon(
                              Icons.person,
                              color: AppColors.primaryGradientStart,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['doctor'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppColors.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  item['specialty'],
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(item['status']),
                  ],
                ),
                const Divider(height: 24, color: AppColors.cardBorder),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppColors.primaryGradientStart,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${item['date']} à ${item['time']}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item['location'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (isUpcoming) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _upcomingAppointments.removeAt(index);
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: BorderSide(color: Colors.redAccent.withAlpha(100)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Annuler'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color textColor;
    Color bgColor;

    switch (status) {
      case 'Confirmé':
        textColor = const Color(0xFF0D9488); // Vert émeraude/Teal
        bgColor = const Color(0xFFCCFBF1);
        break;
      case 'En attente':
        textColor = const Color(0xFFD97706); // Ambré chaleureux
        bgColor = const Color(0xFFFEF3C7);
        break;
      default:
        textColor = AppColors.textSecondary;
        bgColor = const Color(0xFFF3F4F6);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}