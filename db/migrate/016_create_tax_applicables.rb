class CreateTaxApplicables < ActiveRecord::Migration
  def change
    create_table :tax_applicables do |t|

      t.integer :tax_id

      t.float :rate

      t.date :applicable_from

    end

    Tax.all.each do |tax|
      tax_app = TaxApplicable.new(rate: tax.rate, applicable_from: tax.applicable_from)
      t = Tax.where(name: tax.name).first
      tax_app.tax_id = t.id
      tax_app.save
      if tax != t
        tax.delete
      end
    end

  end
end
