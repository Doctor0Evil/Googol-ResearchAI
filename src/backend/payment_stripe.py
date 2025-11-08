# src/backend/payment_stripe.py
import stripe

stripe.api_key = "sk_live_YOUR_SECRET_KEY"

def create_invoice(email, amount, invoice_number, memo, identity, org):
    customer = stripe.Customer.create(
        email=email,
        name=identity,
        description=org
    )
    invoice_item = stripe.InvoiceItem.create(
        customer=customer.id,
        amount=int(amount * 100),
        currency="usd",
        description=f"{memo} | Invoice: {invoice_number}"
    )
    invoice = stripe.Invoice.create(
        customer=customer.id,
        auto_advance=True
    )
    return invoice.hosted_invoice_url

# Usage example:
# url = create_invoice("client@example.com", 99.99, "8CKDNDLA-0001", "Thanks for subscribing!", "Jacob Scott Farmer", "Example Inc.")
# print(url)
