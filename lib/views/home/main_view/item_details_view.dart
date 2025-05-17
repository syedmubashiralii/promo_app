import 'package:flutter/material.dart';
import 'package:flutter_ui/utils/color_helper.dart';

class ItemDetailView extends StatefulWidget {
  const ItemDetailView({super.key});

  @override
  _ItemDetailViewState createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Item Details',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Stack(
                    children: [
                      Container(
                        height: 170,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Image(
                            image: AssetImage('assets/images/watch.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 1,
                        right: 1,
                        child: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () {
                            // Handle favorite toggle
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 8, color: Color(0xffECECEC)),
                        SizedBox(width: 4),
                        Icon(Icons.circle, size: 8, color: ColorHelper.blue),
                        SizedBox(width: 4),
                        Icon(Icons.circle, size: 8, color: Color(0xffECECEC)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Expanded(
                        child: Text(
                          "Fossil Men's Nate Quartz",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        "Free",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoPill(
                        label: "Location",
                        value: "45454",
                        backgroundColor: const Color(0xFFD4E8FF),
                      ),
                      _buildInfoPill(
                        label: "Status",
                        value: "Students",
                        backgroundColor: const Color(0xFFEBDDF9),
                      ),
                      _buildInfoPill(
                        label: "Distance",
                        value: "15 Mile",
                        backgroundColor: const Color(0xFFFFDDE1),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "From an inky matte dial to brushed jet steel, Nate gives the all-black trend new depth. Use it to dress up your favorite pair of denim and a crisp, white tee. This Nate watch also features a chronograph movement on a stainless steel bracelet.",
                    style: TextStyle(color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // Redemption Instructions
                  const Text(
                    "Redemption Instructions",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  const BulletList([
                    "You will receive a unique redemption code.",
                    "Show the code at the participating store or enter it at checkout online.",
                    "Offer valid until 12/12/2025.",
                    "Only one redemption per user."
                  ]),
                  const SizedBox(height: 24),

                  // Eligibility Criteria
                  const Text(
                    "Eligibility Criteria",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  const BulletList([
                    "Must have an active account for at least 7 days.",
                    "Only available to users with \"Up\" status in the past 24 hours.",
                    "Limited to the first 100 redemptions."
                  ]),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),

          // Bottom Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3, // 30% of screen width
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Report", style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55, // 30% of screen width
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorHelper.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Redeem Now", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }

  Widget _buildInfoPill({
    required String label,
    required String value,
    required Color backgroundColor,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class BulletList extends StatelessWidget {
  final List<String> items;

  const BulletList(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("• ",
                        style: TextStyle(fontSize: 14, height: 1.4,color: Colors.grey)),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 14, height: 1.4,color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ))
          .toList(),
    );
  }
}
