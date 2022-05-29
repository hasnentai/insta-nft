import 'package:flutter/cupertino.dart';
import './mint_imports.dart';

class MintFormView extends StatefulWidget {
  const MintFormView({Key? key}) : super(key: key);

  @override
  State<MintFormView> createState() => _MintFormViewState();
}

class _MintFormViewState extends State<MintFormView> {
  late String selectedImage;
  bool isImageSelected = false;
  SessionStatus? sessionStatus;
  final EthereumTransactionTester ethTransction = EthereumTransactionTester();
  MintFormData mintFormData = MintFormData();
  TransactionStatus? status;
  Contract? _c;
  String? hash;
  BigInt? tokenid;

  @override
  void initState() {
    super.initState();

    _c = Contract(
      address: EthereumAddress.fromHex(contractAddress),
      client: ethTransction.ethereum,
    );
  }

  @override
  Widget build(BuildContext context) {
    sessionStatus = context.watch<WalletProvider>().session;
    return Scaffold(
      appBar: renderAppBar(),
      body: renderBodyWithPadding(context),
    );
  }

  _mintToken() async {
    context
        .read<WalletProvider>()
        .setTransactionStatus(TransactionStatus.pending);
    WalletProvider().setTransactionStatus(TransactionStatus.pending);
    mintFormData.imageUrl = selectedImage;
    String jsonData = jsonEncode(mintFormData);
    renderBottomSheet(context, isTransactionUI: true, name: mintFormData.name);
    StreamSubscription<NFTMinted>? subscription;

    subscription = _c!.nFTMintedEvents().listen((event) {
      setState(() {
        tokenid = event.newItemId;
      });
      context
          .read<WalletProvider>()
          .setTransactionStatus(TransactionStatus.success);
      subscription!.cancel();
    });
    String? trx = await UploadJsonFileToIPFS().uploadFile(
        jsonData, ethTransction, ethTransction.connector.session.accounts[0]);
    setState(() {
      hash = trx;
    });
  }

  Padding renderBodyWithPadding(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: renderSingleChildScrollView(context),
    );
  }

  AppBar renderAppBar() {
    return AppBar(
      elevation: 0,
      title: const Text("Mint Form"),
    );
  }

  SingleChildScrollView renderSingleChildScrollView(BuildContext context) {
    return SingleChildScrollView(
      child: renderColumn(context),
    );
  }

  Column renderColumn(BuildContext context) {
    return Column(
      children: [
        renderSelectImageWidget(context),
        renderSpace20(),
        renderNameTextFeild(),
        renderSpace20(),
        renderDescTextFeild(),
        renderSpace20(),
        renderPriceTextFeild(),
        renderSpace20(),
        renderFormSubmitButton(context),
        renderSpace20(),
      ],
    );
  }

  RaisedGradientButton renderFormSubmitButton(BuildContext context) {
    return RaisedGradientButton(
        gradient: gradient,
        onPressed: () => attachCallBackOnPress(context),
        child: renderTextOnSubmitButton());
  }

  attachCallBackOnPress(BuildContext context) {
    sessionStatus == null
        ? context.read<WalletProvider>().walletConnect(ethTransction)
        : _mintToken();
  }

  Text renderTextOnSubmitButton() {
    return sessionStatus != null
        ? const Text("Mint NFT")
        : const Text("Connect Wallet");
  }

  TextField renderPriceTextFeild() {
    return TextField(
      decoration: const InputDecoration(hintText: 'Price'),
      cursorColor: primaryColor,
      onChanged: (text) {
        mintFormData.price = text;
      },
    );
  }

  TextField renderDescTextFeild() {
    return TextField(
      maxLines: 10,
      onChanged: (text) {
        mintFormData.desc = text;
      },
      decoration: const InputDecoration(hintText: 'Description'),
      cursorColor: primaryColor,
    );
  }

  TextField renderNameTextFeild() {
    return TextField(
      decoration: const InputDecoration(hintText: 'Name'),
      cursorColor: primaryColor,
      onChanged: (text) {
        mintFormData.name = text;
      },
    );
  }

  SizedBox renderSpace20() {
    return const SizedBox(
      height: 20.0,
      width: 20.0,
    );
  }

  GestureDetector renderSelectImageWidget(BuildContext context) {
    return GestureDetector(
      onTap: (() => renderBottomSheet(context)),
      child: isImageSelected ? renderImage() : renderImageIcon(),
    );
  }

  Icon renderImageIcon() {
    return const Icon(
      Icons.image,
      size: 300,
    );
  }

  Image renderImage() {
    return Image.network(
      selectedImage,
      height: 300.0,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
  }

  void function(value) => setState(() => {
        selectedImage = value,
        isImageSelected = true,
      });

  Future<void> renderBottomSheet(BuildContext context,
      {isTransactionUI = false, String? name}) {
    return showDialog<void>(
      useSafeArea: false,
      context: context,
      builder: (BuildContext context) {
        status = context.watch<WalletProvider>().status;

        if (!isTransactionUI) {
          return InstagramPhotoSelection(selectImage: function);
        } else {
          return renderAlertDialog(name, context);
        }
      },
    ).then((value) => {
          setState(() {
            hash = null;
            context.read<WalletProvider>().setTransactionStatus(null);
          })
        });
  }

  AlertDialog renderAlertDialog(String? name, BuildContext context) {
    return AlertDialog(
      title: Text(name!),
      scrollable: true,
      content: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  renderImageWithBorderRadius(),
                  renderSpace20(),
                  context.read<WalletProvider>().status !=
                          TransactionStatus.pending
                      ? renderConfirmStatus(context, name)
                      : renderPendingStatus(context, name)
                ],
              ),
              context.read<WalletProvider>().status != TransactionStatus.pending
                  ? renderAnimation()
                  : Container(),
            ],
          ),
          hash != null ? renderViewOnChainButton(context) : Container()
        ],
      ),
    );
  }

  LottieBuilder renderAnimation() {
    return LottieBuilder.asset(
      "assets/animations/celebration.json",
      height: 440,
      width: 400,
      fit: BoxFit.fill,
      repeat: true,
    );
  }

  ClipRRect renderImageWithBorderRadius() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: renderImage(),
    );
  }

  Column renderPendingStatus(BuildContext context, String name) {
    return Column(
      children: [
        renderPendingAnimationWithText(context),
        renderSpace20(),
        renderTextWalletNote(name, context),
        renderSpace20(),
      ],
    );
  }

  Row renderPendingAnimationWithText(BuildContext context) {
    return Row(
      children: [
        const CupertinoActivityIndicator(),
        const SizedBox(
          width: 10.0,
        ),
        renderPendingText(context),
      ],
    );
  }

  OutlinedButton renderViewOnChainButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () =>
          {launchUrlString("https://rinkeby.etherscan.io/tx/$hash")},
      child: renderOutlineButtonText(context),
    );
  }

  Text renderOutlineButtonText(BuildContext context) {
    return Text(
      "View on Rinkeby Chain",
      style: Theme.of(context).textTheme.button,
    );
  }

  Text renderTextWalletNote(String name, BuildContext context) {
    return Text(
      "$name will be available in your wallet once transaction is confirmed",
      style: Theme.of(context).textTheme.caption,
      textAlign: TextAlign.center,
    );
  }

  Text renderPendingText(BuildContext context) {
    return Text(
      "Your Transaction is Pending...",
      style: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(color: Colors.orange, fontWeight: FontWeight.w900),
    );
  }

  Center renderConfirmStatus(BuildContext context, String name) {
    return Center(
      child: Column(
        children: [
          renderMintedText(context),
          renderSpace20(),
          renderTextNote(name, context),
          renderSpace20(),
          tokenid != null ? renderTokenId(context) : Container(),
          renderSpace20(),
        ],
      ),
    );
  }

  Text renderTokenId(BuildContext context) {
    return Text(
      "Token ID : $tokenid",
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Text renderTextNote(String name, BuildContext context) {
    return Text(
      "$name is now available in your wallet to trade",
      style: Theme.of(context).textTheme.caption,
      textAlign: TextAlign.center,
    );
  }

  Text renderMintedText(BuildContext context) {
    return Text(
      "Congratulations Your NFT is live !",
      style: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(color: Colors.greenAccent, fontWeight: FontWeight.w900),
    );
  }
}
