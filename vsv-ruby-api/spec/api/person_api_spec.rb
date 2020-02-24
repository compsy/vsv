=begin
#VSV V1

#No descripton provided (generated by Swagger Codegen https://github.com/swagger-api/swagger-codegen)

OpenAPI spec version: v1

Generated by: https://github.com/swagger-api/swagger-codegen.git

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=end

require 'spec_helper'
require 'json'

# Unit tests for VsvRubyApi::PersonApi
# Automatically generated by swagger-codegen (github.com/swagger-api/swagger-codegen)
# Please update as you see appropriate
describe 'PersonApi' do
  before do
    # run before each test
    @instance = VsvRubyApi::PersonApi.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of PersonApi' do
    it 'should create an instact of PersonApi' do
      expect(@instance).to be_instance_of(VsvRubyApi::PersonApi)
    end
  end

  # unit tests for basic_auth_api_person_show_list_get
  # Shows a list of persons
  # 
  # @param [Hash] opts the optional parameters
  # @option opts [Person] :person 
  # @return [nil]
  describe 'basic_auth_api_person_show_list_get test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for person_me_get
  # Gets the current person
  # 
  # @param [Hash] opts the optional parameters
  # @return [InlineResponse200]
  describe 'person_me_get test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for person_put
  # Updates the current user
  # 
  # @param [Hash] opts the optional parameters
  # @option opts [Person1] :person 
  # @return [InlineResponse200]
  describe 'person_put test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

end