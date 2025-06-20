import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/animated_category_bar.dart';
import '../constants.dart';

class FaqItem {
  final String category;
  final String question;
  final String answer;
  FaqItem(this.category, this.question, this.answer);
}

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({Key? key}) : super(key: key);

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  final categories = ['General', 'Account', 'Service', 'Payment'];
  int _selectedCategory = 0;
  String _search = '';
  final _searchCtrl = TextEditingController();
  final List<FaqItem> _allFaqs = [
    FaqItem('General', 'How do I make a purchase?',
        'When you find a product you want to purchase, tap on it to view the product details. Check the price, description, and available options (if applicable), then tap the "Add to Cart" button...'),
    FaqItem('General', 'How do I reset my password?',
        'On the login screen, tap "Forgot Password" and follow the instructions.'),

    FaqItem('General', 'How do I place a return or exchange? ',
        'It’s our goal to ensure you have the best possible experience with us, and so we offer returns valid for 30 days from the date of arrival. As such, you will be responsible for paying for your own shipping costs for returning your item. To return your item, do email us at saints_scars@gmail.com and mail it back to: '),

    FaqItem('Payment', 'What payment methods are accepted?',
        'We accept Visa, Mastercard, American Express, PayPal and Apple Pay.'),
    FaqItem('Service', 'How can I contact customer support for assistance?',
        'You can reach out via our Help Center or email support@fashionhub.com.'),
    FaqItem('Account', 'How do I reset my password?',
        'On the login screen, tap "Forgot Password" and follow the instructions.'),
    // ... добавьте любые другие
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // отфильтруем
    final filtered = _allFaqs.where((f) {
      if (categories[_selectedCategory] != f.category) return false;
      if (_search.isNotEmpty &&
          !f.question.toLowerCase().contains(_search.toLowerCase())) return false;
      return true;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            // категории
            AnimatedCategoryBar(
              categories: categories,
              selectedIndex: _selectedCategory,
              onTap: (i) => setState(() => _selectedCategory = i),
              backgroundColor: Theme.of(context).colorScheme.primary,
              activeColor: Colors.white,
              inactiveColor: Colors.black,
            ),
            const SizedBox(height: 12),

            // поиск
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Search for questions...',
                          border: InputBorder.none,
                        ),
                        onChanged: (v) => setState(() => _search = v),
                      ),
                    ),
                    const Icon(Icons.mic, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // список вопросов
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filtered.length,
                itemBuilder: (_, idx) {
                  final faq = filtered[idx];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      title: Text(faq.question,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(faq.answer),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
