import 'package:flutter/material.dart';
import 'package:shakti_hormann/features/vehicle_reporting/model/vehicle_reporting_form.dart';

void showVehicleReportingDialog(BuildContext context, VehicleReportingForm vehicleForm) {
  showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade300, // dark background
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // If vehicle front photo available → show it in circle avatar
                // CircleAvatar(
                //   radius: 40,
                //   backgroundImage: vehicleForm.driverIdPhoto != null
                //       ? NetworkImage('http://65.21.243.18:8000${vehicleForm.driverIdPhoto!}')
                //       : const AssetImage('assets/images/placeholder.png') as ImageProvider,
                // ),
                const SizedBox(height: 10),

                // Info rows

                _infoText('Plant Name', vehicleForm.plantName),
                _infoText('Vehicle No', vehicleForm.vehicleNumber),
                _infoText('Driver Contact', vehicleForm.driverContact),
                _infoText('Arrival Date and Time', vehicleForm.arrivalDateAndTime),
                _infoText('Transporter Name', vehicleForm.transporterName),


                const SizedBox(height: 20),

                // Photos Grid Section
                if (vehicleForm.driverIdPhoto != null  
                 ) ...[
                  const Text(
                    'Photos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      if (vehicleForm.driverIdPhoto != null)
                        _photoCard('Vehicle Front', vehicleForm.driverIdPhoto!),
                     
                      
                    ],
                  ),
                ],

                const SizedBox(height: 20),

                // Close button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.brown.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Custom text widget for label + value
Widget _infoText(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: value ?? '-',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    ),
  );
}

/// Helper for photo card
Widget _photoCard(String label, String pathOrUrl) {
  const String baseUrl = 'http://65.21.243.18:8000';
  final String url = pathOrUrl.startsWith('http') ? pathOrUrl : '$baseUrl$pathOrUrl';

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          url,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 100,
            height: 100,
            color: Colors.grey[300],
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image, color: Colors.red),
          ),
        ),
      ),
      const SizedBox(height: 6),
      Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    ],
  );
}
