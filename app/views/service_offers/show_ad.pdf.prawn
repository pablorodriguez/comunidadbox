fs=14
#pdf.image "#{::Rails.root.join('public','images','company_logos','vg_logo.png')}",:at=>[10,800],:scale =>0.40
pdf.image "#{::Rails.root.join('public','images','logo_n.png')}",:at=>[430,800],:scale =>0.60

pdf.move_down(25)

pdf.text @service_offer.company.name,:size=>fs + 2,:style =>:bold
pdf.text @service_offer.company.address.to_text
pdf.text @service_offer.company.phone


pdf.move_down(10)

pdf.text @service_offer.service_types.map(&:native_name).join(", "),:style =>:bold

pdf.move_down(25)

data = [
  [I18n.t("price"),number_to_currency(@service_offer.price)],
  [I18n.t("discount"),number_to_percentage(@service_offer.percent, :precision =>2)],
  [I18n.t("final_price"),number_to_currency(@service_offer.final_price)],
  [I18n.t("since"),I18n.l(@service_offer.since)],
  [I18n.t("until"),I18n.l(@service_offer.until)]
]

pdf.table data do      
  cells.padding = [10,10]
  columns(0..1).width=100
  position = "center"
end

pdf.move_down(25)

pdf.text "#{I18n.t("comment")}: #{@service_offer.comment}"
pdf.text "#{I18n.t("days")}: #{@service_offer.valid_dates.map{|d| I18n.t(d)}.join(" , ")}"
