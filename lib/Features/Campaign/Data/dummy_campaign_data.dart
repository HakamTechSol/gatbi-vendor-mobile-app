import '../Models/campaign_model.dart';

/// Dummy campaigns used during UI development.
///
/// Keep this list empty to test the "No campaigns yet" state.
///
/// Example:
/// final campaigns = dummyCampaigns;
///
/// Empty state:
/// final campaigns = <CampaignModel>[];
final List<CampaignModel> dummyCampaigns = [
  CampaignModel(
    id: 1,
    title: 'Summer Flash Sale',
    description: 'Limited-time discount on selected products.',
    status: CampaignStatus.active,
    startDate: DateTime(2026, 6, 10),
    endDate: DateTime(2026, 6, 30),
    discount: 20,
    productCount: 12,
  ),

  CampaignModel(
    id: 2,
    title: 'Featured Products',
    description: 'Increase visibility by featuring your best products.',
    status: CampaignStatus.scheduled,
    startDate: DateTime(2026, 7, 5),
    endDate: DateTime(2026, 7, 20),
    productCount: 8,
  ),

  CampaignModel(
    id: 3,
    title: 'Bundle & Save',
    description: 'Create product bundles and offer attractive savings.',
    status: CampaignStatus.completed,
    startDate: DateTime(2026, 5, 1),
    endDate: DateTime(2026, 5, 15),
    discount: 15,
    productCount: 6,
  ),
];

/// Use this list when you want to test the empty campaign state.
const List<CampaignModel> emptyCampaigns = [];

/// Suggested campaign ideas shown when the vendor has no campaigns.
class CampaignIdeaModel {
  const CampaignIdeaModel({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final String icon;
}

const List<CampaignIdeaModel> dummyCampaignIdeas = [
  CampaignIdeaModel(
    title: 'Flash Deal',
    description: 'Run a limited-time discount to create urgency.',
    icon: 'flash',
  ),
  CampaignIdeaModel(
    title: 'Featured Listing',
    description: 'Highlight your best-selling products.',
    icon: 'star',
  ),
  CampaignIdeaModel(
    title: 'Bundle Offer',
    description: 'Combine products and offer a special price.',
    icon: 'bundle',
  ),
  CampaignIdeaModel(
    title: 'Free Shipping',
    description: 'Attract customers with a free delivery offer.',
    icon: 'shipping',
  ),
];
