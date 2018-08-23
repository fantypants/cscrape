defmodule Cryptscrape.FindValidTest do
  use Cryptscrape.ModelCase
    alias Cryptscrape.Target
    alias Cryptscrape.Scrape
    alias Cryptscrape.FindValid

    test "test_page_response_is_valid" do
      url = "cingularity.network" #Initial Data Set
      domain_is_valid = FindValid.check_response(url)
      assert domain_is_valid == true
    end

    test "test_page_title_contains_name" do
      url = "cingularity.network"
      domain_has_correct_header = FindValid.check_header(url)
      assert domain_has_correct_header == true
    end

    test "test_page_meta_contains_name" do
      url = "bitdb.network"
      domain_has_correct_header = FindValid.check_meta(url)
      assert domain_has_correct_header == true
    end

    test "test_page_has_name" do
      url = "bitdb.network"
      domain_has_correct_header = FindValid.check_page(url)
      assert domain_has_correct_header == true
    end

    test "test_page_is_valid_and_has_name" do
      valid_url = "bitdb.network"
      invalid_url = "asq-coin.network"
      valid? = FindValid.get_page_name(valid_url)
      invalid? = FindValid.get_page_name(invalid_url)
      assert valid? == true && invalid? == false
    end

    test "URL List contains 2 valid and 1 false" do
      urls = ["asq-coin.network", "bitdb.network", "cingularity.network"]
      checked_domains = FindValid.run_domain_verification(urls)
      valid_domains = checked_domains |> Enum.filter(fn(domain) -> domain.active? == true end) |> Enum.count
      invalid_domains = checked_domains |> Enum.filter(fn(domain) -> domain.active? == false end) |> Enum.count
      assert valid_domains == 2 && invalid_domains == 1
    end


  end
